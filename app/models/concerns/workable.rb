module Workable
  require 'action_view'
  extend ActiveSupport::Concern
  include ActionView::Helpers::TextHelper

  DATE_FORMAT = '%e %B %Y'
  TIME_FORMAT = '%l:%M %p'

  included do

    has_one :work, as: :workable, dependent: :destroy, autosave: true
    delegate :start_date, to: :work, allow_nil: true
    delegate :end_date, to: :work, allow_nil: true
    delegate :user, to: :work, allow_nil: true
    delegate :user_id, to: :work, allow_nil: true
    delegate :duration, to: :work, allow_nil: true

    validate do |workable|
      next if workable.work.nil? || workable.work.valid?
      workable.work.errors.full_messages.each do |msg|
        errors[:base] << msg
      end
    end
  end

  def formatted_start_time
    "#{start_date.strftime("#{TIME_FORMAT}")}".strip if start_date
  end

  def formatted_start_date
    "#{start_date.strftime("#{DATE_FORMAT}")}".strip if start_date
  end

  def formatted_end_time
    "#{end_date.strftime("#{TIME_FORMAT}")}".strip if end_date
  end

  def formatted_end_date
    "#{end_date.strftime("#{DATE_FORMAT}")}".strip if end_date
  end

  def formatted_duration
    return '' if duration.nil?

    secs = duration
    [[60, :second], [60, :minute], [24, :hour], [1000, :day]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        pluralize(n.to_i, name.to_s) if n.to_i > 0
      end
    }.compact.reverse.join(' ')
  end

  def short_dates
    return '' unless work
    return "#{start_date.strftime("#{DATE_FORMAT}")} - #{end_date.strftime("#{DATE_FORMAT}")}" if start_date.to_date != end_date.to_date

    "#{start_date.strftime("#{DATE_FORMAT}")}"
  end

  def short_datetimes
    return '' unless work
    return "#{start_date.strftime("#{DATE_FORMAT} #{TIME_FORMAT}")} - #{end_date.strftime("#{DATE_FORMAT} #{TIME_FORMAT}")}" if start_date.to_date != end_date.to_date

    "#{start_date.strftime("#{DATE_FORMAT}")} #{start_date.strftime("#{TIME_FORMAT}")} - #{end_date.strftime("#{TIME_FORMAT}")}"
  end

  def short_times
    return '' unless work

    "#{start_date.strftime("#{TIME_FORMAT}")} - #{end_date.strftime("#{TIME_FORMAT}")}"
  end

  def user_qualified?
    if user.user_type
      user.user_type.qualified_solicitor?
    else
      true
    end
  end
end
