# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :league do
    name "MyString"
    description "MyText"
    status "MyString"
    owner_id 1
    active false
  end
end
