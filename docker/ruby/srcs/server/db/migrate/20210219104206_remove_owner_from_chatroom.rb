class RemoveOwnerFromChatroom < ActiveRecord::Migration[6.1]
  def change
    remove_column :chatrooms, :owner, :string
  end
end
