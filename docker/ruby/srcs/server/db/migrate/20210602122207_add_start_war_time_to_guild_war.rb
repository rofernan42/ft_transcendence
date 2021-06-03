class AddStartWarTimeToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :start_war_time, :datetime
  end
end
