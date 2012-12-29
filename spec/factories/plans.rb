# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    name "MyString"
    site_id 1
    description "MyText"
    amount 1
    period "MyString"
  end
end
