module CourtDateChildControllerHelper
  extend ActiveSupport::Concern

  included do
    before_action :set_court_date, only: [:new, :edit, :create, :update]

    def set_court_date
      if params[:court_date_id]
        @court_date_id = params[:court_date_id]
        @court_date = CourtDate.find_by_id(@court_date_id)
      end
    end
  end

end
