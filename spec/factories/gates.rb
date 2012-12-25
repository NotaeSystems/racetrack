# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gate do
    number 1
    horse_id 1
    finish 1
    status "MyString"
    race_id 1
  end
end
