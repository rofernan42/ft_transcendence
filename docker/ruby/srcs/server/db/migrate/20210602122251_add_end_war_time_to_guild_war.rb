class AddEndWarTimeToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :end_war_time, :datetime
  end
end
