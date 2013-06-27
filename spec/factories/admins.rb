# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :operator, class: Admin do
    name  "Test Operator"
    email "example@example.com"
    password "please"
    password_confirmation "please"
    role "operator"
  end
  factory :admin, class: Admin do
    name "Test Admin"
    email "admin@example.com"
    password "please"
    password_confirmation "please"
    role "admin"
  end
end
