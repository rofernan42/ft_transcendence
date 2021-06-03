class AddHourToPm < ActiveRecord::Migration[6.1]
  def change
    add_column :private_messages, :date_creation, :string
  end
end
