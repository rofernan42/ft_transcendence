class RemoveLadderFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :ladder, :boolean
  end
end
