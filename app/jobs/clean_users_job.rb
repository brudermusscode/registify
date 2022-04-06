class CleanUsersJob < CronJob
  # set the (default) cron expression
  self.cron_expression = '* * * * *'

  # will enqueue the mailing delivery job
  def perform
    User.where(confirmed_at: nil).where('created_at < ?', 1.day.ago).delete_all
  end
end
