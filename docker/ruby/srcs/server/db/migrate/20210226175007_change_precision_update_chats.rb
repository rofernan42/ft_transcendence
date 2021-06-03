class ChangePrecisionUpdateChats < ActiveRecord::Migration[6.1]
  def change
    change_column :chats, :updated_at, :datetime, :precision => 0
  end
end
