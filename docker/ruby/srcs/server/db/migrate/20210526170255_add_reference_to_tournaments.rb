class AddReferenceToTournaments < ActiveRecord::Migration[6.1]
  def change
    add_reference :tournaments, :user, foreign_key: true
  end
end
