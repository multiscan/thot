# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :borrowing do
    user ""
    item ""
    return_date "2013-01-16"
  end
end
