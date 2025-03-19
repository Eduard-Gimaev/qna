module Services
  class FindForOauth
    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end

    def call
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      email = auth.info[:email]
      user = User.where(email: email).first
      if user
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
      elsif email
        user = create_user_from_oauth(email, auth)
      end
      user
    end

    private

    def create_user_from_oauth(email, auth)
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
      user
    end
  end
end
