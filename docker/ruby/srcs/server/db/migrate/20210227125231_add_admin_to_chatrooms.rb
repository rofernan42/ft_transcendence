class AddAdminToChatrooms < ActiveRecord::Migration[6.1]
  def change
    add_column :chatrooms, :admin, :bigint, array: true, default: []
  end
end
