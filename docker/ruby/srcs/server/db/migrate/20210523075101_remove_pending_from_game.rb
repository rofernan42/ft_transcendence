class RemovePendingFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :pending, :boolean
  end
end
