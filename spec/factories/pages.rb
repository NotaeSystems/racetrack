# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    name "MyString"
    body "MyText"
    site_id 1
    permalink "MyString"
  end
end
