class Work < ActiveRecord::Base

  DATE_FORMAT = '%e %B %Y'
  TIME_FORMAT = '%l:%M %p'

  belongs_to :user
  belongs_to :workable, polymorphic: true

  validates_presence_of :user
  validates_presence_of :start_date
  validates_presence_of :end_date
  validate :end_must_be_after_start_date

  def formatted_start_date
    start_date.strftime "#{DATE_FORMAT} #{TIME_FORMAT}"
  end

  def formatted_end_date
    end_date.strftime "#{DATE_FORMAT} #{TIME_FORMAT}"
  end

  def duration
    end_date - start_date
  end

  private
  def end_must_be_after_start_date
    if start_date && end_date && end_date.to_datetime < start_date.to_datetime
      errors.add(:end_date, "(#{end_date.strftime "#{DATE_FORMAT} #{TIME_FORMAT}"}) must be after end date (#{start_date.strftime "#{DATE_FORMAT} #{TIME_FORMAT}"})")
    end
  end

end
