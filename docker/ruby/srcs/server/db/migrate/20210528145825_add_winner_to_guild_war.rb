class AddWinnerToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :winner, :bigint
  end
end
