class CreateGuilds < ActiveRecord::Migration[6.1]
  def change
    create_table :guilds do |t|
      t.string :name
      t.string :anagram
      t.integer :points
      t.bigint :owner

      t.timestamps
    end
  end
end
