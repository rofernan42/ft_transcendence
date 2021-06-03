class AddMembersToChatrooms < ActiveRecord::Migration[6.1]
  def change
    add_column :chatrooms, :members, :bigint, array: true, default: []
  end
end
