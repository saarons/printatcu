class RemoveStatusFromDocument < ActiveRecord::Migration
  def change
    remove_column :documents, :status
  end
end
