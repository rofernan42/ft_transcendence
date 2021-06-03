class RemoveUserTwoIdFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :user_two_id, :bigint
  end
end
