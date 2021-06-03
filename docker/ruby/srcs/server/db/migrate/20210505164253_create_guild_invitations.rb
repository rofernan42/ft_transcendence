class CreateGuildInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :guild_invitations do |t|
      t.bigint :user_id
      t.bigint :guild_id
      t.boolean :pending

      t.timestamps
    end
  end
end
