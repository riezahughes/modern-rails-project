class Meeting < ActiveRecord::Base
  include Workable
  include Notifiable
  include AccountChargeable
  include DocumentTemplateable

  DATE_FORMAT = '%e %B %Y'
  TIME_FORMAT = '%l:%M %p'

  belongs_to :client_file
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'
  belongs_to :meeting_type
  belongs_to :journey
  belongs_to :witness
  has_one :precognition, dependent: :destroy
  validates_associated :precognition

  validates_presence_of :description
  validates_presence_of :client_file
  validates :length, :numericality => {greater_than_or_equal_to: 0, allow_blank: true}
  validates_presence_of :work
  validates :account_charge_items, length: { maximum: 1 }

  delegate :file_number, to: :client_file, prefix: true, allow_nil: true
  delegate :formatted_identifier, to: :journey, prefix: true, allow_nil: true

  scope :uniquely_attendance_with, -> { group(:attendance_with) }

  scope :by_client_file, ->(client_file) {
    joins(:work)
    .where(client_file: client_file)
  }

  def narrative
    if waiting_times_present?
      return "Attendance with #{attendance_with}, at #{locus}, by #{user}, #{description}.
      Waiting times: #{formatted_waiting_times}
      Meeting: #{formatted_duration}
      Meeting (#{short_times})"
    end

    "Attendance with #{attendance_with}, at #{locus}, by #{user}, #{description}.
    Meeting: #{formatted_duration}
    Meeting (#{short_times})"
  end

  def to_s
    "Meeting #{formatted_start_date}"
  end

  def formatted_waiting_times
    return '' if !waiting_times_present?
    if waiting_date_same_as_work?
      return "#{waiting_time_start.strftime("#{TIME_FORMAT}")} - #{waiting_time_end.strftime("#{TIME_FORMAT}")}"
    end

    if waiting_time_start.to_date != waiting_time_end.to_date
      return "#{waiting_time_start.strftime("#{DATE_FORMAT} #{TIME_FORMAT}")} - #{waiting_time_end.strftime("#{DATE_FORMAT} #{TIME_FORMAT}")}"
    end

    "#{waiting_time_start.strftime("#{DATE_FORMAT}")} #{waiting_time_start.strftime("#{TIME_FORMAT}")} - #{waiting_time_end.strftime("#{TIME_FORMAT}")}"
  end

  def waiting_times_present?
    waiting_time_start && waiting_time_end
  end

  def waiting_date_same_as_work?
    if waiting_times_present? && work
      return waiting_time_start.to_date == start_date.to_date
    end

    return false
  end

  def to_template_values
    current_solicitor = user
    current_solicitor_surname = current_solicitor ? current_solicitor.personal_details.surname : ''
    current_solicitor_initials = current_solicitor ? current_solicitor.initials : ''
    current_solicitor_surname_with_title = current_solicitor ? current_solicitor.personal_details.surname_with_title : ''
    current_solicitor_type = current_solicitor ? current_solicitor.user_type : ''

    {
      description: description,
      locus: locus,
      attendanceWith: attendance_with,
      meetingType: meeting_type,
      times: short_times,
      duration: formatted_duration,
      date: formatted_start_date,
      witness: witness.to_s,
      witnessAddress: witnessAddress,
      solicitorSurname: current_solicitor_surname,
      solicitorInitials: current_solicitor_initials,
      solicitorSurnameWithTitle: current_solicitor_surname_with_title,
      solicitorType: current_solicitor_type
    }
  end

  private
  def witnessAddress
    return '' if witness.nil?

    witness.witnessable.address.gsub(/(\r)?\n/, ', ')
  end
end
