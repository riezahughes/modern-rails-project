class Court < ActiveRecord::Base

  has_many :client_files
  belongs_to :court_type
  belongs_to :police_authority
  belongs_to :jurisdiction

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :court_type
  validates_associated :court_type
  validates_presence_of :police_authority

  delegate :court_official, to: :court_type, prefix: false, allow_nil: true

  def to_s
    name
  end

end
