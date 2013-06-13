class CreateInventorySessions < ActiveRecord::Migration
  def change
    create_table :inventory_sessions do |t|
      t.string     :name
      t.text       :notes
      t.references :admin

      t.timestamps
    end
  end
end
