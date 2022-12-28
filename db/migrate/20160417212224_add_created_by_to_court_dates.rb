class AddCreatedByToCourtDates < ActiveRecord::Migration[4.2]
  def change
    add_reference :court_dates, :user, index: true, foreign_key: true
  end
end
