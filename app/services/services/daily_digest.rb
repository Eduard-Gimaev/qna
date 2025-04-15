class Services::DailyDigest 
  def send_daily_digest
    questions = Question.created_yesterday
    return if questions.empty?
    
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end