class AddAllocatedToClientFiles < ActiveRecord::Migration
  def change
    add_column :client_files, :allocated, :string
  end
end
