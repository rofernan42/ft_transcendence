class AddDefaultValueOneToGuildWar < ActiveRecord::Migration[6.1]
  def change
    change_column :guild_wars, :unanswered_guild_one, :bigint, default: 0
  end
end
