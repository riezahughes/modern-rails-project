class PoliceOfficer < ActiveRecord::Base
  include Witnessable
  belongs_to :police_authority

  validates_presence_of :title
  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:title, :pc_number]

  def to_s
    "#{title} #{name}"
  end

  def address
    return police_authority.address if police_authority?

    ''
  end
end
