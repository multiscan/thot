class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.integer :inventory_session_id
      t.integer :item_id
      t.integer :shelf_id

      t.timestamps
    end
  end
end
