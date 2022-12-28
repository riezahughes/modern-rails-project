class AddWorkableToWorks < ActiveRecord::Migration[4.2]
  def change
    add_reference :works, :workable, polymorphic: true, index: true
  end
end
