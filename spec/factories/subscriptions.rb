# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    name "MyString"
    user_id 1
    site_id 1
    status "MyString"
    plan_id 1
    description "MyText"
    stripe_customer_token "MyString"
    begin_date "2012-12-29 11:30:28"
    expires "2012-12-29 11:30:28"
    amount 1
    period "MyString"
  end
end
