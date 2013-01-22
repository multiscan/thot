class Borrowing < ActiveRecord::Base
  attr_accessible :item, :return_date, :user
end
