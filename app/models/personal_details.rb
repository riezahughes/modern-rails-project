class PersonalDetails < ActiveRecord::Base
  # belongs_to :personable, polymorphic: true
  has_one :personable

  before_save :format_fields

  validates_presence_of :forename
  validates_format_of :forename, with: /\A[^0-9`!@#\$%\^&*+_=]+\z/, allow_blank: true
  validates_presence_of :surname
  validates_format_of :surname, with: /\A[^0-9`!@#\$%\^&*+_=]+\z/, allow_blank: true
  validates_format_of :middlenames, with: /\A[^0-9`!@#\$%\^&*+_=]+\z/, allow_blank: true

  def self.valid_titles
    ['Mr', 'Mrs', 'Ms', 'Miss', 'Mast', 'Dr', 'Prof']
  end

  def middlename_initials
    return '' if self.middlenames.nil? || self.middlenames.blank? || self.middlenames.empty?
    [self.middlenames.split.collect { |middlename| middlename[0].capitalize }].join('. ') << '.'
  end

  def surname_with_title
    return "#{title} #{surname}" unless title.blank?

    surname
  end

  def format_fields

    if title.blank?
      self.title = ''
    else
      formatted_title = title.strip.gsub('.', '').capitalize
      if PersonalDetails.valid_titles.include? formatted_title
        self.title = formatted_title
      else
        self.title = ''
      end
    end

    self.initials = initials.strip.upcase
  end

  private

end
