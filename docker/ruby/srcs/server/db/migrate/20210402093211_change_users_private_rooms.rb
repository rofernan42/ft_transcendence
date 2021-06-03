class ChangeUsersPrivateRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :private_rooms, :users, :bigint, array: true, default: []
  end
end
