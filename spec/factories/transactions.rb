# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    name "MyString"
    amount 1
    description "MyText"
    user_id 1
    site_id 1
    transcription_type "MyString"
    track_id 1
  end
end
