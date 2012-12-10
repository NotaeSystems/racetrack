# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :achievement do
    name "MyString"
    title "MyString"
    url "MyString"
    description "MyText"
    image_url "MyString"
    points 1
    rule "MyText"
    position 1
    status "MyString"
  end
end
