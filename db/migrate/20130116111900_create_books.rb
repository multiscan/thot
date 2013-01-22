class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :editor
      t.string :call1
      t.string :call2
      t.string :call3
      t.string :call4
      t.string :collation
      t.string :isbn
      t.integer :volume
      t.string :edition
      t.references :publisher
      t.string :collection
      t.string :language
      t.text :abstract
      t.text :toc
      t.text :idx
      t.text :notes
      t.integer :publication_year
      t.float :price
      t.string :currency

      t.timestamps
    end
  end
end
