class AttendanceWaitingsController < AuthoritativeController
  include WorkControllerHelper
  include CourtAttendanceControllerHelper
  include ChargeableItemTriggers
  include CourtDateChildControllerHelper

  before_action :set_attendance_waiting, only: [:show, :edit, :update, :destroy]
  # GET /attendance_waitings
  def index
    @search = AttendanceWaiting.includes(court_attendance: :court_date).includes(court_attendance: :work).ransack(params[:q])
    @attendance_waitings = @search.result(distinct: true).paginate(per_page: 10, page: params[:page])
  end

  # GET /attendance_waitings/1
  def show
  end

  # GET /attendance_waitings/new
  def new
    court_attendance = CourtAttendance.new
    @attendance_waiting = AttendanceWaiting.new(court_attendance: court_attendance)
  end

  # GET /attendance_waitings/1/edit
  def edit
  end

  # POST /attendance_waitings
  def create
    @attendance_waiting = AttendanceWaiting.new(attendance_waiting_params)
    add_new_court_attendance @attendance_waiting
    add_new_work @attendance_waiting.court_attendance, @attendance_waiting.model_name.param_key.to_sym
    @chargeable_item = @attendance_waiting.court_attendance

    if @attendance_waiting.save
      redirect_to @attendance_waiting, notice: 'Attendance waiting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /attendance_waitings/1
  def update

    update_court_attendance @attendance_waiting
    update_work @attendance_waiting.court_attendance, @attendance_waiting.model_name.param_key.to_sym
    if @attendance_waiting.update(attendance_waiting_params)
      redirect_to @attendance_waiting, notice: 'Attendance waiting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /attendance_waitings/1
  def destroy
    @attendance_waiting.destroy
    redirect_to attendance_waitings_url, notice: 'Attendance waiting was successfully destroyed.'
    end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attendance_waiting
    @attendance_waiting = AttendanceWaiting.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def attendance_waiting_params
    {}
  end

end
