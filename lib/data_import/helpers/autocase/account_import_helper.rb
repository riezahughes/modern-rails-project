module DataImport::Helpers::Autocase
  class DataImport::Helpers::Autocase::AccountImportHelper

    def corrected_status(status)

      return 'none' if status.blank?

      return 'private' if status =~ /private/i

      return 'no_claim' if status =~ /([mn]o|nil)\s+cl(ai|ia)m/i

      return 'feed' if status =~ /f[fe]ed?/i

      return 'current' if status =~ /current/i

      return 'feed' if status =~ /hig([hn])?\s+contr?ib/i

      return 'feed' if status =~ /lost/i

      return 'not_granted' if status =~ /not\s+granted/i

      'none'
    end

  end
end