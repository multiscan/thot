class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.references :user
      t.references :item
      t.references :book
      t.date :return_date

      t.timestamps
    end
  end
end
