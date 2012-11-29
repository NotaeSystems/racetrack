# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trackuser do
    track_id 1
    user_id 1
    role "MyString"
    allow_comments false
    nickname "MyString"
  end
end
