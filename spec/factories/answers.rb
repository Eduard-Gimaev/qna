# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'AnswerBody' }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
