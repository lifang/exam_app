class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  def welcome_email(user)
    @user = user
    @url  = "http://localhost:3000/"
    mail(:to => user.email, :subject => "欢迎来到赶考")
  end
  def user_affirm(user,examination)
    @exam_user=user
    @user = User.find(user.user_id)
    @examination=examination
    @url  = "http://localhost:3000/"
    mail(:to => @user.email, :subject => "欢迎来到赶考")
  end
  def receive(email)
    page = Page.find_by_address(email.to.first)
    page.emails.create(:subject => email.subject, :body => email.body)
    if email.has_attachments?
      for attachment in email.attachments
        page.attachments.create({:file => attachment, :description => email.subject})
      end
    end
  end
  
end
