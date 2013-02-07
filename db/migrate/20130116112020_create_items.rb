class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :lab
      t.references :location
      t.integer :inv
      t.string :status
      t.float :price
      t.string :currency
      t.references :inventoriable, :polymorphic => true

      t.timestamps
    end
  end
end
