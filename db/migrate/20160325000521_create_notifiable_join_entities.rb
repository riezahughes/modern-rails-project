class CreateNotifiableJoinEntities < ActiveRecord::Migration[4.2]
  def change
    create_table :notifiable_join_entities do |t|
      t.references :notification, index: true, foreign_key: true
      t.references :notifiable, polymorphic: true, index: {name: :index_notifiable_join_entities_on_notifiable_id}

      t.timestamps null: false
    end
  end
end
