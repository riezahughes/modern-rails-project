class CreateDocuments < ActiveRecord::Migration[4.2]
  def change
    create_table :documents do |t|
      t.text :description
      t.references :documentable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
