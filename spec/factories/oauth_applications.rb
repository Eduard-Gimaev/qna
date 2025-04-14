FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test Application' }
    uid { SecureRandom.hex(16) }
    secret { SecureRandom.hex(32) }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    scopes { 'public' }
  end
end
