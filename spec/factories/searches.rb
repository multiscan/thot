# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search do
    title "MyString"
    author "MyString"
    editor "MyString"
    isbn "MyString"
    year "MyString"
    publisher_name "MyString"
    collection "MyString"
    location_id 1
    owner_id 1
    status "MyString"
    user_id 1
  end
end
