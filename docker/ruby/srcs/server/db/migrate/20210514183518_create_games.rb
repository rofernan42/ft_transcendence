class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.bigint :user_one_id
      t.bigint :user_two_id
      t.bigint :user_one_score
      t.bigint :user_two_score
      t.boolean :classic
      t.boolean :giant
      t.boolean :reverse
      t.boolean :faster
      t.boolean :pending
      t.boolean :done

      t.timestamps
    end
  end
end
