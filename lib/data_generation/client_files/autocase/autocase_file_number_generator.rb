class AutocaseFileNumberGenerator < FileNumberGenerator

  def initialize(available_prefix_set = nil, count_limit = 9999)
    @available_prefix_set = available_prefix_set || ('A'..'Z').to_a
    @count_limit = count_limit
  end

  def next_file_number(type)
    prefixes = type.prefixes ? type.prefixes.split(',') : []

    next_prefix = nil

    prefixes.each do |current_prefix|

      if prefix_viable(current_prefix)
        next_prefix = current_prefix
        break
      end

    end

    if next_prefix.nil?

      next_prefix = add_new_prefix_to_type type

    end

    get_file_number_for_prefix(next_prefix)
  end

  private
  def prefix_viable(prefix)
    ClientFile.with_file_number_prefix(prefix).count < @count_limit
  end

  private
  def get_file_number_for_prefix(prefix)
    return '' if prefix.blank?
    file_number_count = ClientFile.with_file_number_prefix(prefix)
                            .collect { |client_file|
                              client_file.file_number.gsub(/[A-Za-z]/, '').to_i
                            }.max || 0

    while file_number_count < @count_limit
      file_number = sprintf('%s%04d', prefix, file_number_count)
      if !ClientFile.exists?(file_number: file_number)
        return file_number
      else
        file_number_count += 1
      end
    end
  end

  private
  def add_new_prefix_to_type(type)

    new_prefix = get_next_prefix_to_use

    present_prefixes = type.prefixes
    if present_prefixes.blank?
      type.prefixes = "#{new_prefix}"
    else
      type.prefixes = "#{present_prefixes},#{new_prefix}"
    end

    type.save!
    new_prefix

  end

  private
  def get_next_prefix_to_use
    used_prefixes = ClientFileType.all.pluck(:prefixes).map { |p| p.split(',') unless p.nil? }.flatten
    leftover_prefixes = @available_prefix_set - used_prefixes
    leftover_prefixes[0]
  end


end
