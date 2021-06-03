class AddDoneToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :done, :boolean
  end
end
