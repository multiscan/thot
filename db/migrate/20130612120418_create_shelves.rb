class CreateShelves < ActiveRecord::Migration
  def change
    create_table :shelves do |t|
      t.integer :location_id
      t.integer :seqno

      t.timestamps
    end
  end
end
