class AddUserToChats < ActiveRecord::Migration[6.1]
  def change
    add_reference :chats, :user, null: true, foreign_key: true
  end
end
