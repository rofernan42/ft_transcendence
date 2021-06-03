class CreatePongsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :pongs do |t|
      t.bigint :user_left_id
      t.bigint :user_right_id
      t.bigint :user_left_score
      t.bigint :user_right_score
      t.string :mode
      t.boolean :pending
      t.boolean :started
      t.boolean :done
      t.timestamps
      t.boolean :playing
      t.bigint :winner
      t.bigint :looser
      t.boolean :tie
      t.bigint :room_id
    end
  end
end
