class AddMatchesToTournament < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :m_playing, :bigint
    add_column :tournaments, :m_ended, :bigint
  end
end
