class RemoveReverseFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :reverse, :boolean
  end
end
