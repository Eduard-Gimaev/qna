FactoryBot.define do
  factory :link do
    name { 'Link_name' }
    url { 'http://google.com' }
    linkable factory: %i[question]
  end
end
