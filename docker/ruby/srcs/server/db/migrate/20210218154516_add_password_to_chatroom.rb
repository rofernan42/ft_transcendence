class AddPasswordToChatroom < ActiveRecord::Migration[6.1]
  def change
    add_column :chatrooms, :password, :string
  end
end
