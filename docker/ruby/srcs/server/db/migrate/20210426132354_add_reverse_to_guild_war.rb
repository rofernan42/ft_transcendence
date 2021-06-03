class AddReverseToGuildWar < ActiveRecord::Migration[6.1]
  def change
    add_column :guild_wars, :reverse, :boolean
  end
end
