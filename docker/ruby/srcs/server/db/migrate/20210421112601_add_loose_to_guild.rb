class AddLooseToGuild < ActiveRecord::Migration[6.1]
  def change
    add_column :guilds, :loose, :bigint
  end
end
