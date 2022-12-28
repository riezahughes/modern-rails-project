class LocationType < ActiveRecord::Base

  has_many :locations

  validates_presence_of :name
  validates_uniqueness_of :name

end
