module Helpers::DescriptionHelper

  def self.formatted_duration(item)
    return 'No time info' if item.chargeable_item.nil? || item.chargeable_item.work.nil?
    Time.at(item.chargeable_item.work.duration).utc.strftime("%Hh%Mm")
  end

end
