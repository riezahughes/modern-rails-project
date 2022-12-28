class Precognition < ActiveRecord::Base
  include DocumentTemplateable
  include AccountChargeable

  belongs_to :meeting

  validates_presence_of :meeting
  validates_uniqueness_of :meeting, allow_nil: true
  validates_presence_of :date_framed

  delegate :client_file, to: :meeting, prefix: false, allow_nil: true
  delegate :created_by, to: :meeting, prefix: false, allow_nil: true

  scope :by_client_file, ->(client_file) {
    joins(:meeting)
    .where('meetings.client_file_id = ?', client_file.id)
  }

  def to_s
    "Precognition: #{description}"
  end

  def user_qualified?
    true
  end

  def client_file=(client_file)
    meeting.update!(client_file: client_file)
  end

  def meeting_date
    return '' unless meeting

    meeting.formatted_start_date
  end

  def narrative
    "Fee for framing precognition (#{length} words)"
  end

  def to_template_values
    precognition = {
      description: description,
      meetingDate: meeting_date
    }

    return meeting.to_template_values.merge(precognition) if meeting

    Meeting.new.to_template_values.merge precognition
  end
end
