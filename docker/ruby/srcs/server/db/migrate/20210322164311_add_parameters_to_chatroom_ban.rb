class AddParametersToChatroomBan < ActiveRecord::Migration[6.1]
  def change
    add_column :chatroom_bans, :end_time, :datetime, null: false
    add_column :chatroom_bans, :user_id, :bigint, null: false
    add_column :chatroom_bans, :chatroom_id, :bigint, null: false
  end
end
