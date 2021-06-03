class AddTieToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :tie, :boolean, default: false 
  end
end
