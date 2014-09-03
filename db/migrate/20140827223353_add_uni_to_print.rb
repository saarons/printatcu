class AddUniToPrint < ActiveRecord::Migration
  def change
    add_column :prints, :uni, :string
  end
end
