FactoryBot.define do
  factory :reward do
    title { 'Reward_Title' }

    trait :invalid do
      title { nil }
    end
  end
end
