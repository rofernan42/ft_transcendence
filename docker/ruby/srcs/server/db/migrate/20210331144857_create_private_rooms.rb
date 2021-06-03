class CreatePrivateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :private_rooms do |t|

      t.timestamps
    end
  end
end
