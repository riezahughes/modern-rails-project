module CourtAttendanceControllerHelper
  extend ActiveSupport::Concern

  included do
  end

  def autocomplete_court_date_identifier
    court_dates = CourtDate.court_date_search_scope(params[:term]).limit(10)
    render json: court_dates.map { |court_date| {id: court_date.id,
                                           label: court_date.formatted_identifier,
                                           value: court_date.formatted_identifier} }
  end

  def court_attendance_params(entity_key)
    params.require(entity_key).permit(:court_date_id)
  end

  def add_new_court_attendance(entity)
    court_attendance_attributes = court_attendance_params(entity.model_name.param_key.to_sym).merge({attendanceable: entity})
    entity.court_attendance = CourtAttendance.new(court_attendance_attributes)
  end

  def update_court_attendance(entity)
    entity.court_attendance.update(court_attendance_params(entity.model_name.param_key.to_sym))
  end

end
