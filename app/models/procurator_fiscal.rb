class ProcuratorFiscal < ActiveRecord::Base

  has_many :client_files

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :address

  def to_s
    name
  end
end
