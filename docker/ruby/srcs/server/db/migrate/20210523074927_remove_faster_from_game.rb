class RemoveFasterFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :faster, :boolean
  end
end
