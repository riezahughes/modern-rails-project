module WitnessControllerHelper
  extend ActiveSupport::Concern

  included do
    autocomplete :client_file, :file_number
  end

  def witnesses_params
    if params[:witnesses]
      params.require(:witnesses).permit!
    else
      {}
    end
  end

  def add_witnesses(entity)
    if witnesses_params
      witnesses_params.each do |_, witness_params|
        entity.witnesses << Witness.new(witness_params.merge({witnessable: entity}))
      end
    end
  end

  def update_witnesses(entity)
    if witnesses_params
      witnesses_params.each do |client_file_id, witness_params|
        witness = entity.witnesses.find_by client_file_id: client_file_id
        if witness
          witness.update witness_params
        else
          entity.witnesses << Witness.new(witness_params.merge({witnessable: entity}))
        end
      end

      entity.witnesses.where.not(client_file_id: witnesses_params.keys).destroy_all
    end
  end

end