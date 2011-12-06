class AddCopiesToPrint < ActiveRecord::Migration
  def change
    add_column(:prints, :copies, :integer)
  end
end
