class AddChatroomIdToChat < ActiveRecord::Migration[6.1]
  def change
    add_reference :chats, :chatroom, foreign_key: true
  end
end
