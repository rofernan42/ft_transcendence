class AddHourToChats < ActiveRecord::Migration[6.1]
  def change
    add_column :chats, :date_creation, :string
  end
end
