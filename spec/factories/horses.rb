# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :horse do
    name "MyString"
    race_id 1
    description "MyText"
    finish 1
  end
end
