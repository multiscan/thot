# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    lab ""
    room ""
    user ""
    inv 1
    status "MyString"
    price 1.5
    currency "MyString"
    inventoriable ""
    inventoriable_type "MyString"
  end
end
