class PapersController < ApplicationController

  def show
    @paper=Paper.find(params[:id])
    @block1=PaperBlock.find(1)     #修改
    @block2=PaperBlock.find(2)     #修改
  end

  def new_step_one
    
  end

  def new_step_two
    @paper=Paper.find(params[:id])
  end

  def create_step_one
    @paper=Paper.create(:creater_id=>cookies[:user_id],:title=>params[:paper][:title],:description=>params[:paper][:description])
    @block=PaperBlock.create(:paper_id=>@paper.id,:title=>params[:paper][:block_title],:description=>params[:paper][:block_description])
    redirect_to "/papers/#{@paper.id}/new_step_two"
  end

   def create_step_two
   
    redirect_to "/papers"
  end
  
  def edit

  end
  
  def index
    cookies[:user_id] = 1
    @papers=Paper.find_by_sql("select * from papers p where p.creater_id=#{cookies[:user_id]}").paginate(:per_page =>10, :page => params[:page],:order => "created_at desc")
  end

  def new
  
  end
  
  def user_exist?
    if User.find_by_id(cookies[:user_id]) != current_user
      redirect_to root_path
    end
  end
end
