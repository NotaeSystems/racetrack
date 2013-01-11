# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contract do
    contract_type "MyString"
    user_id 1
    site_id 1
    gate_id 1
    race_id 1
    number 1
  end
end
