module ApplicationHelper

  class ActionView::Helpers::FormBuilder
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Context

    def multiselected_items_field(collection, options = {})
      @template.content_tag(:ul, class: 'witness-multi-select', style: 'padding-left: 0px;') do
        collection.each do |item|
          yield item
        end
      end
    end

    def submit_change_aware(value=nil, options={})
      current_class = ApplicationHelper.add_submit_aware_class value, options

      button_tag(type: 'submit', class: current_class) do
        '<span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Save changes'.html_safe
      end
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      text_field(method.to_sym, html_options.merge({
        id: "#{object_name}_#{method}-input",
        name: "",
        list: "#{method}-list",
        value: options[:selected] ? collection.find(options[:selected]).send(text_method) : nil
      })) <<
      content_tag(:datalist, id: "#{method}-list") do
        collection.each do |item|
          concat(content_tag(:option, item.send(text_method), 'data-value': item[value_method.to_sym]))
        end
      end <<
      text_field(method.to_sym, { hidden: true })
    end

    def date_select(method, options, html_options)
      current_value = object.send(method)
      date_value = current_value

      if options.has_key?(:default)
        date_value = date_value || options[:default]
      else
        date_value = date_value || Date.today
      end

      attrs = {
                'data-provide' => 'datepicker',
                'value' => date_value ? date_value.strftime('%d/%m/%Y') : ''
              }

      if html_options[:class].blank?
        attrs['class'] = 'date-select'
      else
        unless html_options[:class].include?('date-select')
          html_options[:class] = html_options[:class] << ' date-select'
        end
      end

      if !options[:include_blank] && !attrs['value']
        attrs['value'] = Date.today.strftime('%d/%m/%Y')
      end

      text_field(method.to_sym, attrs.merge(html_options))
    end

    def datetime_select(method, options, html_options)
      date_time_format = '%d/%m/%Y %l:%M %p'
      current_value = object.send(method)
      datetime_value = current_value

      if options.has_key?(:default)
        datetime_value = datetime_value || options[:default]
      else
        datetime_value = datetime_value || DateTime.now
      end

      attrs = {
                'value' => datetime_value ? datetime_value.strftime(date_time_format) : ''
              }

      if html_options[:class].blank?
        attrs['class'] = 'date-time-select'
      else
        unless html_options[:class].include?('date-time-select')
          html_options[:class] = html_options[:class] << ' date-time-select'
        end
      end

      if !options[:include_blank] && !attrs['value']
        attrs['value'] = DateTime.now.strftime(date_time_format)
      end

      text_field(method.to_sym, attrs.merge(html_options))
    end
  end

  def autocomplete_template_name_tag(document_template_type, opts = {})
    autocomplete_field_tag :document_template, '',
      autocomplete_document_templates_name_document_templates_path(document_template_type: document_template_type),
      opts
  end

  def submit_change_aware_tag(value=nil, options={})
    current_class = ApplicationHelper.add_submit_aware_class value, options

    button_tag(type: 'submit', class: current_class) do
      '<span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Save changes'.html_safe
    end
  end

  def court_attendance_path(court_attendace)
    polymorphic_path(court_attendace.attendanceable)
  end

  def datetime_select(object_name, method, options = {}, html_options = {})
    super(object_name, method, options.merge({order: [:day, :month, :year]}), html_options)
  end

  def date_select(object_name, method, options = {}, html_options = {})
    super(object_name, method, options.merge({order: [:day, :month, :year]}), html_options)
  end

  def self.add_submit_aware_class(value, options)
    current_class = ''
    current_class = value[:class].to_s if value
    current_class = options[:class] if options
    current_class.to_s << 'btn btn-default submit-change-aware'
  end
end
