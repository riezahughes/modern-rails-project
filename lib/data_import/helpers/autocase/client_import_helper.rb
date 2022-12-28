module DataImport::Helpers::Autocase
  class DataImport::Helpers::Autocase::ClientImportHelper

    COMPANY_NAME_REGEX = /&|Solicitors/
    LOCAL_AGENT_FORENAME_REGEX = /Bruce|Local/
    LOCAL_AGENT_SURNAME_REGEX = /Short|Agent/

    CLASS_TYPE_MAP = {
        company: CompanyClient,
        person: PersonClient
    }

    @type = nil

    def get_client_class_from_data(data)
      @type = get_client_type(data)
      get_class_from_type(@type)
    end

    def correct_data_for_client(data)
      @type = get_client_type(data)
      get_corrected_data_for_type(@type, data)
    end

    def is_local_agent(personal_details)
      !(personal_details.forename =~ LOCAL_AGENT_FORENAME_REGEX &&
          personal_details.surname =~ LOCAL_AGENT_SURNAME_REGEX).nil?
    end

    private
    def get_client_type(data)
      personal_details = data[:personal_details]
      return :company if is_local_agent(personal_details) ||
                        personal_details.forename =~ COMPANY_NAME_REGEX ||
                        personal_details.middlenames =~ COMPANY_NAME_REGEX ||
                        personal_details.surname =~ COMPANY_NAME_REGEX

      :person
    end

    private
    def get_class_from_type(type)
      PersonClient unless CLASS_TYPE_MAP.include? type
      CLASS_TYPE_MAP[type]
    end

    private
    def get_corrected_data_for_type(type, data)

      if type == :company

        personal_details = data[:personal_details]
        company_name = [personal_details.forename, personal_details.middlenames, personal_details.surname].join(' ').gsub(/\s+/, ' ')
        data[:company_name] = company_name
        personal_details.delete
        data.delete :personal_details

      end

      data
    end

  end
end