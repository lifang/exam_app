# encoding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "lifang@gmail.com"

  def welcome_email(user)
    @user = user
    @url  = Constant::SERVER_PATH
    mail(:to => user.email, :subject =>"欢迎来到赶考" )
  end
  def update_code(user)
    @user=user
    mail(:to => user.email, :subject =>"赶考网密码更新" )
  end
  def user_affirmed(user,examination)
    @exam_user=user
    @user = User.find(user.user_id)
    @examination=examination
    @url  = Constant::SERVER_PATH
    mail(:to => @user.email, :subject => "赶考网考生确认")
  end
  
  def rater_affirm(exam_rater,examination)
    @rater=exam_rater
    @examination=examination
    @url  = Constant::SERVER_PATH
    mail(:to => @rater.email, :subject => "赶考网阅卷老师确认")
  end

  def congratulation_vip(user)
    @user=user
    mail(:to => @user.email, :subject => "恭喜，您已成为赶考网VIP会员")
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

  def check_proofs
#    Constant::PROOF_CHECK
     mail(:to =>"er6788@126.com", :subject => "凭证列表")
  end

  
end
