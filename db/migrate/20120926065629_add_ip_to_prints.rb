class AddIpToPrints < ActiveRecord::Migration
  def change
    add_column :prints, :ip, :string
  end
end
