class ExamUsersController < ApplicationController
  def create

  end
  def login

  end
  def leadin
    @info_class=get_text(params[:user_info])
    i=0
    (0..@info_class.length/3-1).each do
      @user=User.create(:name=>"user",:username=>@info_class[i],:email=>@info_class[i+1],:mobiphone=>@info_class[i+2],:encrypted_password=>"123456")
      ExamUser.create(:user_id=>@user.id,:examination_id=>cookies[:examination_id],:password=>"")
      i +=3
    end
  end
end
