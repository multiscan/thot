class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|

      t.string   :query                 # book (title, author, editor)
      t.string   :isbn                  # book
      t.string   :publisher_name        # book
      t.string   :year_range            # book

      t.string   :inv_range             # item
      t.date     :inv_date_from         # item
      t.date     :inv_date_to           # item
      t.integer  :lab_id                # item
      t.integer  :location_id           # item
      t.string   :status                # item

      t.timestamps
    end
  end
end
