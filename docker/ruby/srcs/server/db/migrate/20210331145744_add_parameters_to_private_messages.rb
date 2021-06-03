class AddParametersToPrivateMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :private_messages, :user, null: false, foreign_key: true
    add_reference :private_messages, :private_room, null: false, foreign_key: true
  end
end
