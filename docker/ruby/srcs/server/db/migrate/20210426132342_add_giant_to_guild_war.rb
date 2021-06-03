class AddGiantToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :giant, :boolean
  end
end
