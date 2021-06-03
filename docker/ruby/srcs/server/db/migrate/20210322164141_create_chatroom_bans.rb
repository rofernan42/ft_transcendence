class CreateChatroomBans < ActiveRecord::Migration[6.1]
  def change
    create_table :chatroom_bans do |t|

      t.timestamps
    end
  end
end
