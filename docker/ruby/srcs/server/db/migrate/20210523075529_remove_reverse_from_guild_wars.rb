class RemoveReverseFromGuildWars < ActiveRecord::Migration[6.1]
  def change
    remove_column :guild_wars, :reverse, :boolean
  end
end
