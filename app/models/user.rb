class User < ActiveRecord::Base

  before_destroy :delete_associations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # has_one :personal_details, as: :personable
  belongs_to :personal_details, dependent: :destroy
  has_and_belongs_to_many :groups, uniq: true
  has_and_belongs_to_many :notifications, uniq: true, join_table: :users_notifications
  has_many :permissions, through: :groups
  has_many :created_clients, class_name: 'Client'
  has_many :created_letters, class_name: 'Letter'
  has_many :created_meetings, class_name: 'Meeting'
  has_many :created_phone_calls, class_name: 'PhoneCall'
  has_many :created_court_dates, class_name: 'CourtDate'
  has_many :journeys
  has_many :works
  has_many :solicitor_client_files, class_name: 'ClientFile', foreign_key: :current_solicitor_id
  has_many :court_dates, through: :solicitor_client_files
  belongs_to :user_type

  validates_presence_of :personal_details
  delegate :initials, to: :personal_details

  validates_presence_of :username
  validates_presence_of :initials
  validates_uniqueness_of :username
  validates_uniqueness_of :email, allow_blank: true
  validates_format_of :email, with: /\A[^@]+@[^@]+\z/, message: 'Invalid email address format', allow_blank: true

  scope :person_name_scope, ->(search) {
    joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
        .where('UPPER(CONCAT(IFNULL(personal_details.title, ""),
              personal_details.forename,
              IFNULL(personal_details.middlenames, ""),
              personal_details.surname
              )) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :sorted_by_names, ->{
    joins(:personal_details)
    .includes(:personal_details)
    .order('personal_details.surname ASC')
    .order('personal_details.forename ASC')
    .order('personal_details.middlenames ASC')
  }

  scope :active, ->{
    where(active: true)
  }

  ransacker :person_name do
    Arel.sql("UPPER(CONCAT(IFNULL(personal_details.title, ''),
              personal_details.forename,
              IFNULL(personal_details.middlenames, ''),
              personal_details.surname))")
  end

  ransacker :id_number do
    Arel.sql("CONVERT(id_number, CHAR(20))")
  end


  def login
    self.username
  end

  def to_s
    full_name
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", {:value => login.downcase}]).first
    else
      where(conditions).first
    end
  end

  validate do |user|
    next if user.personal_details.valid?
    user.personal_details.errors.full_messages.each do |msg|
      errors[:base] << "Personal Deatils Error: #{msg}"
    end
  end

  def save_personal_details
    self.personal_details.save unless self.personal_details.nil?
  end

  def delete_associations
    PersonalDetails.find(self.personal_details.id).delete
  end

  #returns Title Forename Middlenames Surname
  def full_name
    personal_details = self.personal_details
    if personal_details.middlenames.nil?
      "#{personal_details.title} #{personal_details.forename} #{personal_details.surname}"
    else
      "#{personal_details.title} #{personal_details.forename} #{personal_details.middlenames} #{personal_details.surname}"
    end
  end

  #returns Forename M. Surname
  def short_full_name
    personal_details = self.personal_details
    if personal_details.middlenames.nil?
      "#{personal_details.forename} #{personal_details.surname}"
    else
      "#{personal_details.forename} #{personal_details.middlename_initials} #{personal_details.surname}"
    end
  end

end
