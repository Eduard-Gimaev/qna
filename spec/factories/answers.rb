FactoryBot.define do
  factory :answer do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      body { nil }
    end
  end
end
