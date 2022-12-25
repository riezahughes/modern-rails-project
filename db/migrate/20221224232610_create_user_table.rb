class CreateUserTable < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tables do |t|
      t.string :username
      t.string :group
      t.timestamps
    end
  end
end
