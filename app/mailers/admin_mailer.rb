class AdminMailer < ActionMailer::Base
  default from: ENV['ADMIN_EMAIL']
  def welcome_email(admin)
    @admin=admin
    mail(to: @admin.email, subject: "Wellcome to Thot")
  end
end
