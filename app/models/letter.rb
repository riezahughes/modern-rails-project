class Letter < ActiveRecord::Base
  include Notifiable
  include AccountChargeable
  include DocumentTemplateable

  DATE_FORMAT = '%e %B %Y'

  belongs_to :client_file
  belongs_to :created_by, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :letter_date
  validates_presence_of :description
  validates_presence_of :client_file
  validates :length, :numericality => { greater_than_or_equal_to: 0, allow_blank: true }
  validates :account_charge_items, length: { maximum: 1 }

  delegate :file_number, to: :client_file, prefix: true, allow_nil: true

  scope :by_client_file, ->(client_file) {
    where(client_file: client_file)
  }

  def formatted_letter_date
    return '' if self.letter_date.blank?
    self.letter_date.strftime DATE_FORMAT
  end

  def to_s
    "Letter #{formatted_letter_date}"
  end

  def user_qualified?
    true
  end

  def to_template_values
    {
      description: description
    }
  end

end
