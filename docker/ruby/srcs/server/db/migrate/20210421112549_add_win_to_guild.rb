class AddWinToGuild < ActiveRecord::Migration[6.1]
  def change
    add_column :guilds, :win, :bigint
  end
end
