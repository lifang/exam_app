class PapersController < ApplicationController

  def show
    @paper=Paper.find(params[:id])

  end

  def edit

  end
  def index
    cookies[:user_id] = 1
    @papers=Paper.find_by_sql("select * from papers p where p.creater_id=#{cookies[:user_id]}").paginate(:per_page =>10, :page => params[:page],:order => "created_at desc")
  end
  def user_exist?()
    if User.find_by_id(cookies[:user_id]) != current_user
      redirect_to root_path
    end
  end
end
