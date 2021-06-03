class ChangeParamsTournaments < ActiveRecord::Migration[6.1]
  def change
    remove_column :tournaments, :user_id, :bigint
    add_column :tournaments, :auto, :boolean, default: false
  end
end
