class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :editor
      t.string :call1, :limit=>8
      t.string :call2, :limit=>16
      t.string :call3, :limit=>8
      t.string :call4, :limit=>8
      t.string :collation
      t.string :isbn, :limit=>24
      t.integer :volume
      t.string :edition
      t.references :publisher
      t.string :collection
      t.string :collation
      t.string :language, :limit=>16
      t.text :abstract
      t.text :toc
      t.text :idx
      t.text :notes
      t.integer :pubyear
      t.float :price
      t.string :currency, :limit=>8

      t.timestamps
    end
  end
end
