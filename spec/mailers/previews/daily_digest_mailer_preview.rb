# Preview all emails at http://localhost:3000/rails/mailers/daily_digest_mailer
class DailyDigestMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/daily_digest_mailer/digest
  delegate :digest, to: :DailyDigestMailer
end
