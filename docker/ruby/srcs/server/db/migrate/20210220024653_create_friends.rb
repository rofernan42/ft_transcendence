class CreateFriends < ActiveRecord::Migration[6.1]
  def change
    create_table :friends do |t|
      t.bigint :user_one_id
      t.bigint :user_two_id

      t.timestamps
    end
  end
end
