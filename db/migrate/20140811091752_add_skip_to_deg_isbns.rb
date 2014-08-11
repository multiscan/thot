class AddSkipToDegIsbns < ActiveRecord::Migration
  def change
    add_column :deg_isbns, :skip, :boolean, :default => false
  end
end
