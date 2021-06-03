class AddOfficerToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :officer, :boolean
  end
end
