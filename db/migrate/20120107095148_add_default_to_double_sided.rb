class AddDefaultToDoubleSided < ActiveRecord::Migration
  def change
    change_column_default :prints, :double_sided, true
  end
end
