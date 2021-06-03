class AddScoreToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :score, :bigint, default: 1000
  end
end
