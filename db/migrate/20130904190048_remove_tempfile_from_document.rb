class RemoveTempfileFromDocument < ActiveRecord::Migration
  def change
    remove_column :documents, :tempfile
  end
end
