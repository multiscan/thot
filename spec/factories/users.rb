# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:visitor] do
    name  "Test User"
    email "example@example.com"
    password "please"
    password_confirmation "please"
  end
  factory :admin, class: User do
    name "Test Admin User"
    email "admin@example.com"
    password "please"
    password_confirmation "please"
    role "admin"
  end
end
