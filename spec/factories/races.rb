# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :race do
    name "MyString"
    card_id 1
    open false
    start_betting_time "2012-11-24 12:14:28"
    post_time "2012-11-24 12:14:28"
    description "MyText"
    completed false
    completed_date ""
  end
end
