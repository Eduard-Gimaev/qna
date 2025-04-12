FactoryBot.define do
  factory :question do
    title { 'Question Title' }
    body { 'Question Body' }
    user
  end

  trait :invalid do
    title { nil }
  end
end
