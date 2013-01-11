# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer do
    user_id 1
    market "MyString"
    price 1
    gate_id 1
    expires "2013-01-08 06:07:10"
    offer_type "MyString"
    number 1
  end
end
