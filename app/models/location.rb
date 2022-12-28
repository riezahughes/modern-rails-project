class Location < ActiveRecord::Base

  has_many :clients
  belongs_to :location_type

  validates_presence_of :name
  validates_presence_of :address
  validates_presence_of :location_type
  validates_uniqueness_of :name

  def to_s
    name
  end

end
