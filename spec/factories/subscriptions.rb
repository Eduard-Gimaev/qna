FactoryBot.define do
  factory :subscription do
    user { association :user }
    question { association :question }
  end
end
