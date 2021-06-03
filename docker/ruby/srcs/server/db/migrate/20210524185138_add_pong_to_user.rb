class AddPongToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :pong, :bigint
  end
end
