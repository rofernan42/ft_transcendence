class RemoveFasterFromGuildWars < ActiveRecord::Migration[6.1]
  def change
    remove_column :guild_wars, :faster, :boolean
  end
end
