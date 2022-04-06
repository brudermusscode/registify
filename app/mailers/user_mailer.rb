class UserMailer < ActionMailer::Base
  default from: Devise.mailer_sender

  def unlocked_account
    @user = params[:user]
    mail(to: @user.email, subject: I18n.t('mail.unlocked_by_admin'))
  end
end
