class AddParametersToPrivateMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :private_messages, :message, :string
  end
end
