# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    user_id 1
    meet_id 1
    race_id 1
    card_id 1
    track_id 1
    body "MyText"
  end
end
