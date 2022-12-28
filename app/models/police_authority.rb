class PoliceAuthority < ActiveRecord::Base

  has_many :courts

  validates_presence_of :name
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :police_constable

  def to_s
    name
  end

end
