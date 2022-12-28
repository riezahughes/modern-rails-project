class FileForm < ActiveRecord::Base
  include DocumentTemplateable

  belongs_to :created_by, class_name: 'User'
  belongs_to :client_file
  belongs_to :witness

  validates_presence_of :client_file
  validates_presence_of :form_date
  validates_presence_of :description

  delegate :file_number, to: :client_file, prefix: true, allow_nil: true

  def to_s
    "File Form #{form_date}"
  end

  def to_template_values
    {
      description: description,
      witness: witness.to_s,
      witnessAddress: witness_address,
      inlineWitnessAddress: inline_witness_address
    }
  end

  private
  def witness_address
    return '' if witness.nil?

    witness.witnessable.address
  end

  def inline_witness_address
    witness_address.gsub(/(\r)?\n/, ', ')
  end
end
