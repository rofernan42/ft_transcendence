class ChangePrecisionChats < ActiveRecord::Migration[6.1]
  def change
    change_column :chats, :created_at, :datetime, :precision => 0
  end
end
