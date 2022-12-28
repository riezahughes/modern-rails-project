class CreatePermissions < ActiveRecord::Migration[4.2]
  def change
    create_table :permissions do |t|
      t.string :subject_class
      t.string :action

      t.timestamps
    end

    create_table :groups_permissions, :id => false do |t|
      t.references :permission
      t.references :group
    end

    add_index :groups_permissions, [:permission_id, :group_id]
    add_index :groups_permissions, :group_id
  end
end
