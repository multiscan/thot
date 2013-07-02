class Lab < ActiveRecord::Base
  has_many :users
  has_many :items
  has_many :book_items, -> {where(inventoriable_type: "Book").includes(:inventoriable)}, :class_name => "Item"
  # has_many :objects, :through => :join_association, :source => :join_association_table_foreign_key_to_objects_table
  has_and_belongs_to_many :operators, :class_name => "Admin", :join_table => "operatorships"
  has_many :locations, -> {uniq}, :through => :items
  # TODO: add count caches for items and users: http://railscasts.com/episodes/23-counter-cache-column
end
