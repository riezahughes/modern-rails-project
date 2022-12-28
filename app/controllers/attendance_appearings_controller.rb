class AttendanceAppearingsController < ApplicationController
  include WorkControllerHelper
  include CourtAttendanceControllerHelper
  include ChargeableItemTriggers
  include CourtDateChildControllerHelper

  before_action :set_attendance_appearing, only: [:show, :edit, :update, :destroy]
  # GET /attendance_appearings
  def index
    @search = AttendanceAppearing.includes(court_attendance: :court_date).includes(court_attendance: :work).ransack(params[:q])
    @attendance_appearings = @search.result(distinct: true).paginate(per_page: 10, page: params[:page])
  end

  # GET /attendance_appearings/1
  def show
  end

  # GET /attendance_appearings/new
  def new
    court_attendance = CourtAttendance.new
    @attendance_appearing = AttendanceAppearing.new(court_attendance: court_attendance)
  end

  # GET /attendance_appearings/1/edit
  def edit
  end

  # POST /attendance_appearings
  def create
    @attendance_appearing = AttendanceAppearing.new(attendance_appearing_params)
    add_new_court_attendance @attendance_appearing
    add_new_work @attendance_appearing.court_attendance, @attendance_appearing.model_name.param_key.to_sym
    @chargeable_item = @attendance_appearing.court_attendance

    if @attendance_appearing.save
      redirect_to @attendance_appearing, notice: 'Attendance appearing was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /attendance_appearings/1
  def update

    update_court_attendance @attendance_appearing
    update_work @attendance_appearing.court_attendance, @attendance_appearing.model_name.param_key.to_sym
    if @attendance_appearing.update(attendance_appearing_params)
      redirect_to @attendance_appearing, notice: 'Attendance appearing was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /attendance_appearings/1
  def destroy
    @attendance_appearing.destroy
    redirect_to attendance_appearings_url, notice: 'Attendance appearing was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attendance_appearing
    @attendance_appearing = AttendanceAppearing.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def attendance_appearing_params
    params.require(:attendance_appearing).permit(:counsel)
  end
end
