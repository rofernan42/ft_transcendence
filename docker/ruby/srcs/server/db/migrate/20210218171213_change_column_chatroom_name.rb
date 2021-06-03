class ChangeColumnChatroomName < ActiveRecord::Migration[6.1]
  def change 
    change_column_null :chatrooms, :name, false
    change_column_null :chatrooms, :chatroom_type, false
    add_column :chatrooms, :owner, :string
  end
end
