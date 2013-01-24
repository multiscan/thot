class CreateDegIsbns < ActiveRecord::Migration
  def up
    create_table :deg_isbns do |t|
      t.string :isbn
      t.integer :count
      t.timestamps
    end
    # # moved to seed.rb
    # Book.duplicated_isbn_count.each do |isbn,count|
    #   i=DegIsbn.create(:isbn=>isbn, :count=>count)
    # end
  end
  def down
    drop_table :deg_isbns
    # drop_table :degisbn_book
  end
end
