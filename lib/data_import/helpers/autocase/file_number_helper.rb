module DataImport::Helpers::Autocase
  class DataImport::Helpers::Autocase::FileNumberHelper

    PREFIX_TYPE_MAP = {
        'A' => :criminal,
        'B' => :criminal,
        'D' => :criminal,
        'T' => :criminal,
        'V' => :criminal,
        'W' => :criminal,
        'X' => :criminal,
        'Y' => :criminal,
        'Z' => :criminal,
        'H' => :child,
        'L' => :immigrant,
        'U' => :immigrant,
        'C' => :civil,
        'Q' => :civil,
        'F' => :civil,
        'M' => :family,
        'R' => :none
    }

    def get_type_by_prefix(prefix)
      PREFIX_TYPE_MAP[prefix]
    end

    def get_client_file_type(file_number)
      return nil if file_number.blank?

      prefix_match = file_number.scan(/^([A-z]+)/)

      return nil if prefix_match.blank?

      prefix = prefix_match[0][0].upcase

      return nil unless PREFIX_TYPE_MAP.has_key? prefix

      type = get_type_by_prefix prefix

      client_file_type = ClientFileType.find_by_name(type.to_s.humanize)
      unless client_file_type
        client_file_type = ClientFileType.new
        client_file_type.name = type.to_s.humanize
        client_file_type.prefixes = PREFIX_TYPE_MAP.map{ |k,v| v==type ? k : nil }.compact.join(',')
        client_file_type.save!
      end
      client_file_type
    end

  end
end
