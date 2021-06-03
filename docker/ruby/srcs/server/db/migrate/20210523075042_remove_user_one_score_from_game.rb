class RemoveUserOneScoreFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :user_one_score, :bigint
  end
end
