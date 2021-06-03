class AddParametersToTournaments < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :user_reward, :bigint, default: 0
    add_column :tournaments, :guild_reward, :bigint, default: 0
    add_column :tournaments, :started, :boolean, default: false
  end
end
