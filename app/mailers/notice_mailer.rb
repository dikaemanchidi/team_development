class NoticeMailer < ApplicationMailer
  default from: 'from@example.com'

  def agenda_remove_mail(email,user,agenda)
    @email= email
    @user= user
    @agenda =agenda
    mail to: @email,  subject: 'Agenda Remove notice'
  end
end
