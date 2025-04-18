class CalculateReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    CalculateReputation.call(object)
  end
end
