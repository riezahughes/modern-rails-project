class TravelMethod < ActiveRecord::Base

  has_many :travels

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    self.name
  end

end
