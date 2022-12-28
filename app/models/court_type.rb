class CourtType < ActiveRecord::Base

  has_many :courts
  belongs_to :court_official

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :recipient
  validates_associated :court_official, allow_blank: true

  def to_s
    name
  end

end
