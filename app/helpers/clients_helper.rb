module ClientsHelper

  include Reports::AccountExpenditureReport
  include Reports::ClientBalanceReport
  include Reports::LedgerTotalReport

  CLASS_TYPE_MAP = {
      company: CompanyClient,
      person: PersonClient
  }

  def client_type_for_selection(client)
    return :company if client.class == CompanyClient
    return :person if client.class == PersonClient
    :person
  end

  def client_type_options_for_select
    [
        ['Person', :person],
        ['Company', :company]
    ]
  end

  def get_client_from_params(type, client_params, personal_details_params)
    type = type.to_sym
    client_class = CLASS_TYPE_MAP[type]

    client = client_class.new(client_params)

    if type == :person
      personal_details = PersonalDetails.new(personal_details_params)
      client.personal_details = personal_details
    end

    client
  end

  def update_client(type, client, client_params, personal_details_params)
    type = type.to_sym

    if type == :person
      personal_details_update = client.personal_details.update(personal_details_params)
      return false unless personal_details_update
    end

    client.update(client_params)

  end

  def get_private_account_type
    AccountType.private_account.first
  end

end
