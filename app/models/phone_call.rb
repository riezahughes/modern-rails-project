class PhoneCall < ActiveRecord::Base
  include Notifiable
  include Workable
  include AccountChargeable

  belongs_to :client_file
  belongs_to :created_by, class_name: 'User', foreign_key: :user_id

  validates_presence_of :client_file
  validates_presence_of :description
  validates_presence_of :work

  validates :account_charge_items, length: { maximum: 1 }

  delegate :file_number, to: :client_file, prefix: true, allow_nil: true

  scope :uniquely_attendance_with, -> { group(:attendance_with) }

  scope :by_client_file, ->(client_file) {
    where(client_file: client_file)
  }

  def narrative
    "Attendance on the telephone, by #{user}, with #{client_file.client}, #{description}
    Phone call: #{formatted_duration} (#{short_times})"
  end

  def to_s
    "Phone Call #{formatted_start_date}"
  end
end
