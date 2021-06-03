class RemoveDuelFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :duel, :boolean
  end
end
