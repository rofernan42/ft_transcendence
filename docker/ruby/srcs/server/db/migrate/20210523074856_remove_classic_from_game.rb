class RemoveClassicFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :classic, :boolean
  end
end
