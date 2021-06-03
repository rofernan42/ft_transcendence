class RemoveUserOneIdFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :user_one_id, :bigint
  end
end
