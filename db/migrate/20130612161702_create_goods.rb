class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.integer :inventory_session_id
      t.integer :item_id
      t.integer :inv
      t.integer :current_shelf_id
      t.integer :previous_shelf_id
      t.timestamps
    end
  end
end
