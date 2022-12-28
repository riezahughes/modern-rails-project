class AddFollowingCourtDateTypeToCourtDateType < ActiveRecord::Migration
  def change
    add_reference :court_date_types, :following_court_date_type, index: true
    add_foreign_key :court_date_types, :court_date_types, column: :following_court_date_type_id
  end
end
