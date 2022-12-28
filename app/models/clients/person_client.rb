class PersonClient < Client

  belongs_to :personal_details, dependent: :destroy

  validates_presence_of :personal_details

  scope :find_by_client_identifiers, ->(client) {
    joins(:personal_details).where(birth_date: client.birth_date)
        .where('personal_details.forename = ? AND
                personal_details.surname = ? AND ' <<
                   "personal_details.middlenames #{client.personal_details.middlenames.nil? ? 'IS' : '='} ?",
               client.personal_details.forename,
               client.personal_details.surname,
               client.personal_details.middlenames)
  }

  validate do |client|
    next if client.personal_details.valid?
    client.personal_details.errors.full_messages.each do |msg|
      errors[:base] << "Personal Details Error: #{msg}"
    end
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

  def forename_name
    personal_details.forename
  end

  #returns Title Forename M. Surname
  def short_full_name
    personal_details = self.personal_details
    if personal_details.middlenames.nil?
      "#{personal_details.forename} #{personal_details.surname}"
    else
      "#{personal_details.forename} #{personal_details.middlename_initials} #{personal_details.surname}"
    end
  end

  def formatted_birth_date
    return '' if self.birth_date.blank?
    self.birth_date.strftime BIRTH_DATE_FORMAT
  end

  def identifiers_are_unique
    clients = PersonClient.find_by_client_identifiers(self)

    unless clients.empty?
      unless clients.count == 1 && clients.first.id == self.id
        errors.add(:base, "Client with this name, birth date already exists")
      end
    end
  end

  def self.model_name
    base_class.model_name
  end

end
