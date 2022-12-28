class CreateMeetings < ActiveRecord::Migration[4.2]
  def change
    create_table :meetings, :options => 'COLLATE=utf8_general_ci' do |t|
      t.text :description
      t.string :locus
      t.integer :length

      t.timestamps null: false
    end
  end
end
