FactoryBot.define do
  factory :answer do
    body { 'MyText' }

    trait :invalid do
      body { '' }
    end
  end
end
