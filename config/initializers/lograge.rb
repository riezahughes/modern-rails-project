Rails.application.configure do
  config.colorize_logging = false
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::KeyValue.new
  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
      params: event.payload[:params].except(*exceptions),
      remote_ip: event.payload[:remote_ip]
    }
  end
end
