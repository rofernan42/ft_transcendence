class AddBlockListToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :block_list, :bigint, array: true, default: []
  end
end
