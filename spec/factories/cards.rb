# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :card do
    name "MyString"
    meet_id 1
    open false
    description "MyText"
    completed false
    completed_date "2012-11-24 11:16:35"
  end
end
