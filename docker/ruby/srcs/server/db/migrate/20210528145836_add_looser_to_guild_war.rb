class AddLooserToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :looser, :bigint
  end
end
