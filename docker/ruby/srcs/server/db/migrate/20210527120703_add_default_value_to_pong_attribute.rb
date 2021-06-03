class AddDefaultValueToPongAttribute < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :pong, :bigint, default: 0
  end
end
