class AddMutedToChatrooms < ActiveRecord::Migration[6.1]
  def change
    add_column :chatrooms, :muted, :bigint, array: true, default: []
  end
end
