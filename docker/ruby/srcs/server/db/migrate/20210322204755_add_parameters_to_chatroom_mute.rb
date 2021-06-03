class AddParametersToChatroomMute < ActiveRecord::Migration[6.1]
  def change
    add_column :chatroom_mutes, :end_time, :datetime, null: false
    add_column :chatroom_mutes, :user_id, :bigint, null: false
    add_column :chatroom_mutes, :chatroom_id, :bigint, null: false
  end
end
