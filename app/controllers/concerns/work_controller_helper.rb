module WorkControllerHelper
  extend ActiveSupport::Concern

  included do
  end

  def work_params(entity_key)
    params.require(entity_key).permit(:user_id, :start_date, :end_date)
  end

  def add_new_work(entity, entity_key = nil, override_work_params = nil)
    entity_key ||= entity.model_name.param_key.to_sym
    new_work_params = override_work_params || work_params(entity_key)

    entity.work = Work.new(new_work_params)
  end

  def update_work(entity, entity_key = nil)
    entity_key ||= entity.model_name.param_key.to_sym
    entity.work.update(work_params(entity_key))
  end

end
