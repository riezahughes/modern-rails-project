class Civilian < ActiveRecord::Base
  include Witnessable

  validates_presence_of :title
  validates_presence_of :name
  validates_presence_of :address
  validates_uniqueness_of :name, scope: :title

  def to_s
    "#{title} #{name}"
  end

end
