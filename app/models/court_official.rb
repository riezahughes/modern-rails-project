class CourtOfficial < ActiveRecord::Base

  has_many :court_types
  belongs_to :court_official_type

  validates_presence_of :name
  validates_associated :court_official_type
  validates_presence_of :court_official_type

  def formatted_name
    "#{self.type_name} #{self.name}"
  end

  def type_name
    "#{self.court_official_type.name}"
  end

  def to_s
    formatted_name
  end

end
