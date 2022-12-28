class Jurisdiction < ActiveRecord::Base

  has_many :courts

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    name
  end

end
