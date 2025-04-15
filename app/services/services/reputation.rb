class Services::Reputation
  def self.calculate(object)
    # return unless object.is_a?(Question) || object.is_a?(Answer)

    # user = object.user
    # return unless user

    # reputation = Reputation.find_or_initialize_by(user: user)
    # reputation.value ||= 0

    # case object
    # when Question
    #   reputation.value += 5 if object.persisted?
    #   reputation.save!
    # when Answer
    #   reputation.value += 3 if object.persisted?
    #   reputation.save!
    # end
  end
end