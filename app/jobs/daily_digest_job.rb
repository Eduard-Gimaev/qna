class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    Services::DailyDigest.new.send_daily_digest
  end
end
