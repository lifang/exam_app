class ExamUsersController < ApplicationController
  def create

  end
  def login
    (1..params[:rows].to_i).each do |i|
         @user=User.new(:name=>params["infoname#{i}"],:username=>params["infoname#{i}"],:email=>params["infoemail#{i}"],:mobilephone=>params["infomobile#{i}"],:password=>"123456",:password_confirmation=>"123456")
      @user.status = User::STATUS[:NORMAL]
      @user.encrypt_password
      ExamUser.create!(:user_id=>@user.id,:examination_id=>cookies[:examination_id],:password=>"123456",:user_affirm=>params[:message])
     
    end
    if params[:exam_code]==1
      Examination.find(cookies[:examination_id]).update_attributes(:exam_password1=>proof_code(6),:exam_password2=>proof_code(6))
    end
    if params[:login_form_value]=="save" or params[:leadin_form_value] == "save"
      redirect_to "/exam_users/new_exam_two"
    else
      redirect_to "/exam_raters/new_exam_three"
    end
      
  end
  def leadin
    @info_class=get_text(params[:user_info])
    i=0
    (0..@info_class.length/3-1).each do
      @user=User.new(:name=>@info_class[i],:username=>@info_class[i],:email=>@info_class[i+1],:mobiphone=>@info_class[i+2],:password=>"123456",:password_confirmation=>"123456",:status=>1)
        @user.encrypt_password
      ExamUser.create!(:user_id=>@user.id,:examination_id=>cookies[:examination_id],:password=>"123456",:user_affirm=>params[:message])
      i +=3
    end
    if params[:exam_code]==1
      Examination.find(cookies[:examination_id]).update_attributes(:exam_password1=>proof_code(6),:exam_password2=>proof_code(6))
    end
    if params[:buttonvalue]=="保存"
      redirect_to "/exam_users/new_exam_two"
    else
      redirect_to "/exam_raters/new_exam_three"
    end
  end
end
