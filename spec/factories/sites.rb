# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    name "MyString"
    description "MyText"
    owner_id 1
    initial_credits 1
    facebook_key "MyString"
    facebook_secret "MyString"
    twitter_key "MyString"
    twitter_secret "MyString"
    domain "MyString"
    slug "MyString"
    status "MyString"
    sanctioned "MyString"
  end
end
