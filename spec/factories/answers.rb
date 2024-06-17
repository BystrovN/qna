FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    question
    user

    trait :invalid do
      body { '' }
    end
  end
end
