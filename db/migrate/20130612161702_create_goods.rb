class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.integer :inventory_session_id
      t.integer :item_id
      t.integer :current_shelf_id
      t.integer :previous_shelf_id
      t.integer :commit, :default => 0  # 0=none, 1=move, 2=missing, 3=move+missing
      t.timestamps
    end
  end
end
