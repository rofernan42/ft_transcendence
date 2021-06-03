class AddFasterToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :faster, :boolean
  end
end
