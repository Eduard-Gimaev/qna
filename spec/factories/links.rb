FactoryBot.define do
  factory :link do
    name { 'Link_name' }
    url { 'http://google.com' }
    association :linkable, factory: :question
  end
end