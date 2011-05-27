class ExamUsersController < ApplicationController
  def create_exam_user
 
    user = User.new(:name=>params[:infoname],:username=>params[:infoname],:email=>params[:infoemail],
      :mobilephone=>params[:infomobile],:password=>"123456",:password_confirmation=>"123456")
    user.status = User::STATUS[:NORMAL]
    user.encrypt_password
    user.save!
    exam_user = ExamUser.create!(:user_id=>user.id,:examination_id=>params[:examination_id],:password=>"123456",
      :is_user_affiremed=>ExamUser::IS_USER_AFFIREMED[:NO],:total_score=>0)
    @examination = Examination.find(params[:examination_id].to_i)
    exam_user.set_paper(@examination)
    @exam_users = ExamUser.paginate_exam_user(@examination.id, 1, params[:page])
    render :partial => "/examinations/exam_user_for_now"
  end
  
  def login
    #    (1..params[:rows].to_i).each do |i|
    #         @user=User.new(:name=>params["infoname#{i}"],:username=>params["infoname#{i}"],:email=>params["infoemail#{i}"],:mobilephone=>params["infomobile#{i}"],:password=>"123456",:password_confirmation=>"123456")
    #      @user.status = User::STATUS[:NORMAL]
    #      @user.encrypt_password
    #      ExamUser.create!(:user_id=>@user.id,:examination_id=>cookies[:examination_id],:password=>"123456",:user_affirm=>params[:message])
    #    end
    if params[:login]==1
    @info=params[:textarea].split(";")
    @info.each do |info|
      @textarea=info.split(",")
        @user=User.new(:name=>@textarea[0],:username=>@textarea[0],:email=>@textarea[2],:mobilephone=>@textarea[1],:password=>"123456",:password_confirmation=>"123456")
        @user.status = User::STATUS[:NORMAL]
        @user.encrypt_password
        @user.save!
        ExamUser.create!(:user_id=>@user.id,:examination_id=>params[:id],:password=>"123456",:user_affirm=>params[:message])
    end
    if params[:exam_code]==1
      Examination.find(cookies[:examination_id]).update_attributes(:exam_password1=>proof_code(6),:exam_password2=>proof_code(6))
    end
   
else
    @info_class=get_text(params[:user_info])
    i=0
    (0..@info_class.length/3-1).each do
      @user=User.new(:name=>@info_class[i],:username=>@info_class[i],:email=>@info_class[i+1],:mobilephone=>@info_class[i+2],:password=>"123456",:password_confirmation=>"123456",:status=>1)
      @user.encrypt_password
      puts @user.id
      ExamUser.create!(:user_id=>@user.id,:examination_id=>cookies[:examination_id],:password=>"123456",:user_affirm=>params[:message])
      i +=3
    end
    if params[:exam_code]==1
      Examination.find(cookies[:examination_id]).update_attributes(:exam_password1=>proof_code(6),:exam_password2=>proof_code(6))
    end
   
  end
   if params[:buttonvalue]=="保存"
      redirect_to "/exam_users/new_exam_two"
    else
      redirect_to "/exam_raters/new_exam_three"
    end
  end

  def destroy
    exam_user = ExamUser.find(params[:id].to_i)
    exam_user.user.destroy
    exam_user.destroy
      @examination = Examination.find(exam_user.examination_id)
     @exam_users =ExamUser.paginate_exam_user(exam_user.examination_id, 1, params[:page])
    render :partial=>"/examinations/exam_user_for_now"
#    render :inline => ""
  end
  def edit
    @exam_user =ExamUser.find(params[:id].to_i)
      @user=User.find(ExamUser.find(params[:id].to_i).user_id)
    render :partial=>"/examinations/edit_exam_user"
  end

  def update_exam_user
    @exam_user =ExamUser.find(params[:id].to_i)
      @user=User.find(ExamUser.find(params[:id].to_i).user_id)
       @user.update_attributes(:name=>params[:name],:username=>params[:name],:email=>params[:email],
      :mobilephone=>params[:mobilephone])
    render :partial=>"/examinations/back_exam_user"
   end
end
