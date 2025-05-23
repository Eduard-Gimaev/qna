class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid)
    return authorization.user if authorization

    email = auth.info[:email]
    return nil unless email

    user = User.find_or_create_by(email: email) do |a|
      a.password = Devise.friendly_token[0, 20]
      a.password_confirmation = a.password
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
