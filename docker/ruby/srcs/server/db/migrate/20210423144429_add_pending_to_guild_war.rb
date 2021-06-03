class AddPendingToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :pending, :boolean
  end
end
