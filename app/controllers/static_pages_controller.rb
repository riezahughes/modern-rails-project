class StaticPagesController < ApplicationController

  def home
    @upcoming_court_dates = current_user.court_dates.upcoming.limit(5)
    @past_court_dates = current_user.court_dates.past.limit(2)
  end

  def help
  end

  def document_templates_help
  end
end
