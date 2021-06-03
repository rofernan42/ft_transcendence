class AddFirstLoggedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_time, :boolean, default: true
  end
end
