class RenameOwnerFromChatroom < ActiveRecord::Migration[6.1]
  def change
    rename_column :chatrooms, :user_id, :owner
  end
end
