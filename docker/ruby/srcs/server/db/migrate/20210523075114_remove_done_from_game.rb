class RemoveDoneFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :done, :boolean
  end
end
