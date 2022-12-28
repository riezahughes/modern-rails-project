class MeetingsController < AuthoritativeController
  include HideDefaultList
  include WorkControllerHelper
  include NotifiableActions
  include ChargeableItemTriggers
  include DocumentTemplateableActions
  include DocumentTemplateableHelper
  include ClientFileChildControllerHelper

  before_action :set_meeting, only: [:show, :edit, :update, :destroy]
  before_action :set_precognition_templated_document, only: [:new, :edit, :create, :update]

  autocomplete :client_file, :file_number
  autocomplete :meeting, :attendance_with, scopes: [:uniquely_attendance_with]
  autocomplete :journey, :identifier

  def autocomplete_journey_identifier
    journeys = Journey.journey_search_scope(params[:term]).limit(10)
    render json: journeys.map { |journey| {id: journey.id,
                                           label: journey.formatted_identifier,
                                           value: journey.formatted_identifier} }
  end

  # GET /meetings
  def index
    @search = Meeting.ransack(params[:q])
    @search.sorts = ['created_at desc'] if @search.sorts.empty?
    @meetings = hidden_results(@search).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /meetings/1
  def show
    @precognition = @meeting.precognition
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings
  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.created_by = current_user
    add_new_work @meeting
    @chargeable_item = @meeting
    save_templated_document_to_templateable @meeting
    set_word_count @meeting
    add_or_update_precognition @meeting

    if @meeting.save
      redirect_to @meeting, notice: 'Meeting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /meetings/1
  def update
    update_work @meeting
    save_templated_document_to_templateable @meeting
    add_or_update_precognition @meeting

    if @meeting.update(meeting_params)
      redirect_to @meeting, notice: 'Meeting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /meetings/1
  def destroy
    @meeting.destroy
    redirect_to @meeting.client_file, notice: 'Meeting was successfully destroyed.'
  end

  private

  def add_or_update_precognition(meeting)
    precognition_templated_document_id = precognition_params[:templated_document_id]
    if precognition_templated_document_id
      precognition_templated_document = TemplatedDocument.find(precognition_templated_document_id)

      if precognition_templated_document.document_templateable
        precognition = precognition_templated_document.document_templateable
        meeting.precognition = precognition
      else
        precognition = Precognition.find_or_initialize_by(meeting: meeting, description: 'N/A', date_framed: meeting.start_date)
      end

      precognition_templated_document.update!(document_templateable: precognition)
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def set_notifiable
    @notifiable = Meeting.find(params[:id])
  end

  def set_precognition_templated_document
    if params[:precognition_templated_document_id]
      @precognition_templated_document = TemplatedDocument.find(params[:precognition_templated_document_id])
    end
  end

  def set_document_templateable
    @document_templateable = Meeting.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def meeting_params

    params.require(:meeting).permit(:description,
                                    :waiting_time_start,
                                    :waiting_time_end,
                                    :locus,
                                    :length,
                                    :client_file_id,
                                    :attendance_with,
                                    :meeting_type_id,
                                    :journey_id,
                                    :document_template_id,
                                    :templated_document, :witness_id)

  end

  def precognition_params
    return params.require(:precognition).permit(:templated_document_id) if params[:precognition]

    {}
  end
end
