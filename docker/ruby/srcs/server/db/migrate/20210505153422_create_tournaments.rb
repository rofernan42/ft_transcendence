class CreateTournaments < ActiveRecord::Migration[6.1]
  def change
    create_table :tournaments do |t|
      t.datetime :start_time
      t.bigint :winner

      t.timestamps
    end
  end
end
