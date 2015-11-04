class AppMailer < ActionMailer::Base
  default from: "Danyeboah Flix"

  def send_welcome_mail(user)
    @user = user
    mail to: user.email, subject: "Welcome to Danyeboah Flix"
  end 

end