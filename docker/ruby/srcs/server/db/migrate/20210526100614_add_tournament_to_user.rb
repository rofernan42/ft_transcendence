class AddTournamentToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :tournament, :bigint
    add_column :users, :eliminated, :boolean, default: false
  end
end
