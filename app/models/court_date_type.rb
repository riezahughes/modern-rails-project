class CourtDateType < ActiveRecord::Base

  has_many :court_dates, dependent: :destroy
  belongs_to :following_court_date_type, class_name: 'CourtDateType'
  validate :cannot_follow_self

  monetize :preparation_pennies

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    name
  end

  def cannot_follow_self
     errors.add(:following_court_date_type, 'Court date type cannot follow itself') if !following_court_date_type_id.nil? && following_court_date_type_id == self.id
  end
end
