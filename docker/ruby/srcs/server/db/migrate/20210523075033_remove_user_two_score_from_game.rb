class RemoveUserTwoScoreFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :user_two_score, :bigint
  end
end
