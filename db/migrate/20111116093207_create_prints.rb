class CreatePrints < ActiveRecord::Migration
  def change
    create_table :prints do |t|
      t.string :building, :printer, :filename, :tempfile, :user
      t.boolean :double_sided
      t.timestamps
    end
  end
end
