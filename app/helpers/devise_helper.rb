module DeviseHelper
  def devise_error_messages!(_resource = nil)
    errors = resource.errors
    name = resource.class.model_name.human.downcase
    return "" if errors.empty?

    messages = errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    sentence = I18n.t("errors.messages.not_saved",
                      :count => errors.count,
                      :resource => name)

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end

end