# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    title "MyString"
    author "MyString"
    editor "MyString"
    call1 "MyString"
    call2 "MyString"
    call3 "MyString"
    call4 "MyString"
    collation "MyString"
    isbn "MyString"
    edition "MyString"
    publisher ""
    collection "MyString"
    language "MyString"
    abstract "MyText"
    toc "MyText"
    idx "MyText"
    notes "MyText"
    publication_year 1
    price 1.5
    currency "MyString"
  end
end
