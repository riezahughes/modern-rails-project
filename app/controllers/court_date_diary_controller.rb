class CourtDateDiaryController < AuthoritativeController

  skip_authorize_resource
  authorize_resource :court_date, parent: false

  def show
    @date = date_param || Date.today
    @next_day = date_to_hash(@date + 1.day)
    @previous_day = date_to_hash(@date - 1.day)
    @court_dates = CourtDate.where('court_date >= ? AND court_date < ?', @date, @date + 1.day)
  end

  private
  def date_param
    date = params.permit(date: [:day, :month, :year])[:date]

    if date
      Date.new(date[:year].to_i, date[:month].to_i, date[:day].to_i)#
    else
      nil
    end
  end

  def date_to_hash(date)
    {year: date.year, month: date.month, day: date.day}
  end
end
