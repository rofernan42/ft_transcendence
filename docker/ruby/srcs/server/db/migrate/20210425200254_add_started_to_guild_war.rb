class AddStartedToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :started, :boolean
  end
end
