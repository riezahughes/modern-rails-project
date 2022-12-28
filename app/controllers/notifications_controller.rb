class NotificationsController < AuthoritativeController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]
  # GET /notifications
  def index
    @search = Notification.ransack(params[:q])
    @notifications = @search.result(distinct: true).paginate(:per_page => 10, :page => params[:page])
  end

  # GET /notifications/1
  def show
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
    @notifiables = unused_notifibles
    @users = User.all
  end

  # GET /notifications/1/edit
  def edit
    @notifiables = unused_notifibles
    @users = User.all
  end

  # POST /notifications
  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      redirect_to @notification, notice: 'Notification was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /notifications/1
  def update
    if @notification.update(notification_params)
      redirect_to @notification, notice: 'Notification was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /notifications/1
  def destroy
    @notification.destroy
    redirect_to notifications_url, notice: 'Notification was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = Notification.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def notification_params

    params.require(:notification).permit(:entity, user_ids: [])

  end

  def unused_notifibles
    Notifiable.classes - Notification.uniq.pluck(:entity)
  end
end
