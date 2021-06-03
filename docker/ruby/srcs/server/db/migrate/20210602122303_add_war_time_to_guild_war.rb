class AddWarTimeToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :war_time, :boolean
  end
end
