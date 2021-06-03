class ChangeGuildWarsParams < ActiveRecord::Migration[6.1]
  def change
    change_column :guild_wars, :duels, :boolean, default: false
    change_column :guild_wars, :ladder, :boolean, default: false
  end
end
