class AddBannedToChatrooms < ActiveRecord::Migration[6.1]
  def change
    add_column :chatrooms, :banned, :bigint, array: true, default: []
  end
end
