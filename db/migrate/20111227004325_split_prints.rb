class SplitPrints < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :print
      t.string :filename, :tempfile
      t.timestamps
    end

    remove_column :prints, :filename, :tempfile
  end
end