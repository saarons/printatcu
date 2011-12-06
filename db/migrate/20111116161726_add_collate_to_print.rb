class AddCollateToPrint < ActiveRecord::Migration
  def change
    add_column(:prints, :collate, :boolean)
  end
end
