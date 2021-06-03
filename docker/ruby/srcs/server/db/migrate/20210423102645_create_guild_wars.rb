class CreateGuildWars < ActiveRecord::Migration[6.1]
  def change
    create_table :guild_wars do |t|
      t.datetime :start
      t.datetime :end
      t.bigint :prize
      t.bigint :guild_one_id
      t.bigint :guild_two_id
      t.bigint :guild_one_points
      t.bigint :guild_two_points
      t.bigint :unanswered_match
      t.boolean :duels
      t.boolean :ladder

      t.timestamps
    end
  end
end
