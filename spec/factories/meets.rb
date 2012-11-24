# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meet do
    name "MyString"
    track_id 1
    open false
    description "MyText"
    completed false
    completed_date "2012-11-24 07:59:14"
  end
end
