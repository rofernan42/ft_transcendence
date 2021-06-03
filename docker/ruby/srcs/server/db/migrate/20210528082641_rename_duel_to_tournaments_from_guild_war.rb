class RenameDuelToTournamentsFromGuildWar < ActiveRecord::Migration[6.1]
  def change
    rename_column :guild_wars, :duels, :tournaments
  end
end
