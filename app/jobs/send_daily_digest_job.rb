class SendDailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    SendDailyDigest.call
  end
end
