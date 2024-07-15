FactoryBot.define do
  factory :answer do
    title { "AnswerTitle" }
    body { "AnswerBody" }

    trait :invalid do
      body { nil }
    end
  end
end
