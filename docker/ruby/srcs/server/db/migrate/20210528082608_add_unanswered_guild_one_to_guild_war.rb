class AddUnansweredGuildOneToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :unanswered_guild_one, :bigint
  end
end
