FactoryBot.define do
  factory :vote do
    votable { nil }
    value { 1 }
    user
  end
end
