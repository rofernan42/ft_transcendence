class AddWarToGuild < ActiveRecord::Migration[6.1]
  def change
    add_column :guilds, :war, :bigint
  end
end
