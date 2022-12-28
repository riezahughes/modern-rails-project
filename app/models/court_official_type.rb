class CourtOfficialType < ActiveRecord::Base

  has_many :court_officials

  validates_presence_of :name
  validates_uniqueness_of :name

end
