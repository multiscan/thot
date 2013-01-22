class CreateBorrowings < ActiveRecord::Migration
  def change
    create_table :borrowings do |t|
      t.references :user
      t.references :item
      t.date :return_date

      t.timestamps
    end
  end
end
