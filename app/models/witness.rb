class Witness < ActiveRecord::Base
  belongs_to :client_file
  belongs_to :witnessable, polymorphic: true
  has_many :meetings, dependent: :nullify
  has_many :forms, dependent: :nullify

  validates_presence_of :client_file
  validates_presence_of :witnessable
  validates_uniqueness_of :client_file, scope: [:witnessable_id, :witnessable_type], message: "already has this witness"

  scope :cited, -> { where(cited: true) }

  def to_selection_item
    return "#{witnessable} - Cited" if cited?

    witnessable
  end

  def to_s
    witnessable.to_s
  end

end
