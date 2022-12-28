class CreateGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :groups_users, :id => false do |t|
      t.references :group
      t.references :user
    end

    add_index :groups_users, [:group_id, :user_id]
    add_index :groups_users, :user_id
  end
end
