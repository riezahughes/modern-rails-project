class Client < ActiveRecord::Base

  include AlfrescoConnection
  include AlfrescoClient

  EMAIL_ADDRESS_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  UK_NATIONAL_INSURANCE_NUMBER = /\A\s*([a-zA-Z]){2}(\s*[0-9]\s*){6}([a-zA-Z]){1}?\z/
  BIRTH_DATE_FORMAT = '%e %B %Y'

  has_many :client_files, dependent: :destroy
  has_many :ledgers, dependent: :destroy
  has_many :accounts, through: :client_files
  has_many :documents, as: :documentable
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'
  belongs_to :location

  validates_format_of :email_address, with: EMAIL_ADDRESS_REGEX, allow_blank: true
  validates_format_of :national_insurance_number, with: UK_NATIONAL_INSURANCE_NUMBER, allow_blank: true
  validate :identifiers_are_unique

  scope :find_by_client_identifiers, ->(client) { none }

  def self.ransackable_scopes(auth_object = nil)
    [:client_search_scope,
      :person_fuzzy_name_scope,
      :person_forename_scope,
      :person_surname_scope,
      :birth_date_scope,
      :national_insurance_number_scope,
      :client_file_scope]
  end

  scope :client_search_scope, ->(search) {
    joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
        .joins('LEFT JOIN locations ON location_id = locations.id')
        .where(
            unscoped
                .person_forename_scope(search)
                .person_surname_scope(search)
                .birth_date_scope(search)
                .company_name_scope(search)
                .location_scope(search)
                .where_values.join(' OR ')) #TODO: hack to chain all the where's with ors, this should be fixed with Rails 5's where().or.where() chaining
  }

  scope :client_name_scope, ->(search) {
    joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
        .includes(:personal_details)
        .joins('LEFT JOIN locations ON location_id = locations.id')
        .where(
            unscoped
                .person_fuzzy_name_scope(search)
                .company_name_scope(search)
                .where_values.join(' OR ')) #TODO: hack to chain all the where's with ors, this should be fixed with Rails 5's where().or.where() chaining
  }

  scope :full_person_fuzzy_name_scope, ->(search) {
    joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
        .where('UPPER(CONCAT(IFNULL(personal_details.title, ""),
              personal_details.forename,
              IFNULL(personal_details.middlenames, ""),
              personal_details.surname
              )) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :person_fuzzy_name_scope, ->(search) {
    joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
        .where('UPPER(CONCAT(
              personal_details.forename,
              personal_details.surname
              )) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :person_name_scope, ->(search) {
    joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
        .where('UPPER(personal_details.surname) = ?', "#{search.upcase}")
  }

  scope :person_forename_scope, ->(search) {
    joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
        .where('UPPER(
              personal_details.forename
              ) = ?', "#{search.upcase}")
  }

  scope :person_surname_scope, ->(search) {
    joins('LEFT JOIN personal_details ON personal_details_id = personal_details.id')
        .where('UPPER(
              personal_details.surname
              ) = ?', "#{search.upcase}")
  }

  scope :company_name_scope, ->(search) {
    where('UPPER(company_name) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :location_scope, ->(search) {
    joins('LEFT JOIN locations ON location_id = locations.id')
        .where('UPPER(locations.name) LIKE ?', "%#{search.upcase.gsub(/\s/, '%')}%")
  }

  scope :birth_date_scope, ->(search) {
    search = Date.parse(search) rescue nil
    where('birth_date = ?', search)
  }

  scope :national_insurance_number_scope, ->(search) {
    where('national_insurance_number = ?', search)
  }

  scope :client_file_scope, ->(search) {
    joins(:client_files)
      .where('file_number = ?', search)
  }

  ransacker :surname_sort do
    Arel.sql("COALESCE(personal_details.surname, company_name)")
  end

  ransacker :forename_sort do
    Arel.sql("COALESCE(personal_details.forename, company_name)")
  end

  ransacker :middlenames_sort do
    Arel.sql("COALESCE(personal_details.middlenames, company_name, '')")
  end

  ransacker :location_name_sort do
    Arel.sql("locations.name")
  end

  def delete_associations
    raise 'Method missing'
  end

  def full_name
    raise 'Method missing'
  end

  def forename_name
    ''
  end

  def short_full_name
    raise 'Method missing'
  end

  def to_s
    short_full_name
  end

  def folder_name
    raise 'Method missing'
  end

  def short_address
    self.address.gsub('\n', '').truncate(length: 30, omission: '...')
  end

  def formatted_birth_date
    return '' if self.birth_date.blank?
    self.birth_date.strftime BIRTH_DATE_FORMAT
  end

  def folder_name
    require 'digest/md5'

    sanitized_name = short_full_name.gsub(/^.*(\\|\/)/, '')

    if birth_date
      sanitized_birth_date = formatted_birth_date.gsub(/(\\|\/)/, '-').gsub(/\s/, '')
    else
      sanitized_birth_date = ''
    end

    if address
      address_hash = Digest::MD5.hexdigest(address)[0..8]
    else
      address_hash = ''
    end

    [sanitized_name, sanitized_birth_date, address_hash].select{|part| !part.blank?}.join('_').gsub(/[^0-9A-Za-z.\-]|\s+/, '_')
  end

  def folder_description
    "#{full_name}\r\n#{formatted_birth_date}\r\n#{address}"
  end

  def get_alfresco_folder
    id = get_alfresco_id folder_name

    if !(@repository.nil?) && id.nil?
      raise ObjectNotFound.new 'Folder has not been created yet'
    end

    object = get_object_by_id id
    if object
      DocumentStoreFolder.new object
    else
      nil
    end
  end

  def create_folder

    unless @repository
      connect_to_alfresco
    end

    begin
      object = create_client_folder @repository, self.folder_name, self.folder_description
    rescue FolderExists
      object = get_object_by_id get_id_for_name(self.folder_name)
    end


    if object
      self.update(alfresco_id: object.cmis_object_id)
      DocumentStoreFolder.new object
    else
      nil
    end
  end

  def presence_of_contact_information

    information_not_present = (self.address.blank? && self.postcode.blank?) &&
      self.mobile_telephone.blank? &&
      self.home_telephone.blank? &&
      self.contact_telephone.blank? &&
      self.email_address.blank? &&
      self.additional_contact_information.blank?

    errors.add(:base, "Client contact information is missing, \
please add at least one of address, \
postcode, mobile, home, other contact numbers, email address or any other information") if information_not_present

  end

  protected
  def identifiers_are_unique
    raise 'Method missing'
  end

end
