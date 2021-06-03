class AddDefaultValueTwoToGuildWar < ActiveRecord::Migration[6.1]
  def change
    change_column :guild_wars, :unanswered_guild_two, :bigint, default: 0
  end
end
