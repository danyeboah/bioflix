class AppMailer < ActionMailer::Base
  default from: "danyeboahdeveloper@gmail.com"

  def send_welcome_mail(user)
    @user = user
    mail to: user.email, subject: "Welcome to Danyeboah Flix"
  end 

end