# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bet do
    user_id 1
    horse_id 1
    amount 1
    bet_type "MyString"
    meet_id 1
  end
end
