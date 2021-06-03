class AddGuildToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :guild, :bigint
  end
end
