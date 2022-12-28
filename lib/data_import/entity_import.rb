class DataImport::EntityImport

  attr_accessor :date_wrap_char, :import_since_date

  def get_entity
    raise 'method missing'
  end

  def get_entity_class
    raise 'method missing'
  end

  def get_entity_name
    get_entity_class.name.humanize.pluralize
  end

  def import(entity_records, parent_record = nil)
    @parent = parent_record
    entities_added = 0
    total = entity_records.count

    Rails.logger.info "Importing #{get_entity_name}"

    entity_records.each_with_index do |entity_record, index|
      begin
        # p "(#{index}/#{total})"
        entities_added += 1 if import_record entity_record
      rescue => e
        Rails.logger.error "Cannot import #{get_entity_name} record: #{entity_record}"
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")
      end
    end

    Rails.logger.info "#{entities_added} #{get_entity_name} added"
    entities_added
  end

  protected
  def import_record(record)

    record_data = prepare_data record
    record_data_string = record_data.map{|k,v| "#{k}=\"#{v.inspect}\""}.join(', ')
    if skip_record record_data
      Rails.logger.info "Skipping #{get_entity_name} #{record_data_string}"
      return false
    end
    model = create_model record_data

    original_model = get_duplicate model

    successful_import = false
    if original_model.nil?
      if create_new model
        successful_import = true
      end
    else
      if update original_model, record_data
        successful_import = true
        model = original_model
      end
    end

    if successful_import
      on_import model, record
    else

      vaildation_errors = 'No validation errors'
      if model.errors.any?
        vaildation_errors = model.errors.inspect
      end
      Rails.logger.warn "Cannot import original record:\n#{record.inspect}\nprepared data:\n#{record_data_string}\nmodel:\n#{model.inspect}\nerrors: #{vaildation_errors}"
    end

    successful_import
  end

  def prepare_data(record)
    raise 'method missing'
  end

  def skip_record(data)
    raise 'method missing'
  end

  def create_model(data)
    raise 'method missing'
  end

  def get_duplicate(model)
    raise 'method missing'
  end

  def update(original, new_data)
    raise 'method missing'
  end

  def create_new(model)
    raise 'method missing'
  end

  def on_import(model, record)
    raise 'method missing'
  end

  def delete_all
    raise 'method missing'
  end


end
