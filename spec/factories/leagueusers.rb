# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :leagueuser do
    user_id 1
    league_id 1
    status "MyString"
    nickname "MyString"
    active false
  end
end
