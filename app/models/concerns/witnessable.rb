module Witnessable
  extend ActiveSupport::Concern

  included do
    has_many :witnesses, as: :witnessable, dependent: :destroy, autosave: true
    has_many :client_files, through: :witnesses
    delegate :file_number, to: :client_file, prefix: true, allow_nil: true

    validate do |witnessable|
      witnessable.witnesses.each do |witness|
        next if witness.valid?
        witness.errors.full_messages.each do |msg|
          # errors[:base] << "Witness Error: #{msg}"
        end
      end
    end
  end

end