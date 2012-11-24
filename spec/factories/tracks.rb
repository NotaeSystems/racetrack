# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :track do
    name "MyString"
    owner_id 1
    public false
    open false
    description "MyText"
  end
end
