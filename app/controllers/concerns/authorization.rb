module Authorization
  extend ActiveSupport::Concern

  included do
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore
      action_name = exception.query.chomp('?')
      flash[:alert] = "You are not authorized to perform the #{action_name} action on this #{policy_name.gsub('_policy', '')}."
      redirect_to(request.referrer || root_path)
    end
  end
end