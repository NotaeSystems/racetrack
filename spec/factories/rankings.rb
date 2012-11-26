# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ranking do
    user_id 1
    meet_id 1
    amount "9.99"
    rank "MyString"
  end
end
