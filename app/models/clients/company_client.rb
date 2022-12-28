class CompanyClient < Client

  validates_presence_of :company_name

  scope :find_by_client_identifiers, ->(client) {
    where(company_name: client.company_name, address: client.address)
  }

  def delete_associations
  end

  def full_name
    company_name
  end

  def forename_name
    company_name
  end

  def short_full_name
    company_name
  end

  def formatted_birth_date
    return '' if self.birth_date.blank?
    self.birth_date.strftime BIRTH_DATE_FORMAT
  end

  def identifiers_are_unique
    clients = CompanyClient.find_by_client_identifiers(self)

    unless clients.empty?
      unless clients.count == 1 && clients.first.id == self.id
        errors.add(:base, "Client with this name and address already exists")
      end
    end
  end

  def self.model_name
    base_class.model_name
  end

end
