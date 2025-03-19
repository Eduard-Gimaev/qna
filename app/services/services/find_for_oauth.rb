module Services
  class FindForOauth
    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end

    def call
      authorization = find_authorization
      return authorization.user if authorization

      email = auth.info[:email]
      return nil unless email

      user = find_or_create_user(email)
      user.create_authorization(auth)
      user
    end

    private

    def find_authorization
      Authorization.find_by(provider: auth.provider, uid: auth.uid)
    end

    def find_or_create_user(email)
      User.find_or_create_by(email: email) do |user|
        user.password = Devise.friendly_token[0, 20]
        user.password_confirmation = user.password
      end
    end
  end
end
