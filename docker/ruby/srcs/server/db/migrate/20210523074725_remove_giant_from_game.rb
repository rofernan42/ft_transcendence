class RemoveGiantFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :giant, :boolean
  end
end
