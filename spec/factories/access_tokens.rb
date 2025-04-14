FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    resource_owner_id { create(:user).id }
    application factory: %i[oauth_application]
    token { SecureRandom.hex(16) }
    expires_in { 2.hours }
    scopes { 'public' }
  end
end
