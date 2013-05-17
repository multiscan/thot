class Lab < ActiveRecord::Base
  attr_accessible :name, :nick
  has_many :users
  has_many :items
  has_many :book_items, :class_name => "Item", :conditions=>{:inventoriable_type=>"Book"}, :include => :inventoriable
  has_many :objects, :through => :join_association, :source => :join_association_table_foreign_key_to_objects_table
  has_and_belongs_to_many :operators, :class_name => "User", :join_table => "operatorships"
end
