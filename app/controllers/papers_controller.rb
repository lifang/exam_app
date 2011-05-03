class PapersController < ApplicationController

before_filter :access?
 def index
    @papers=Paper.find_by_sql("select * from papers p where p.creater_id=#{cookies[:user_id]}").paginate(:per_page =>10, :page => params[:page],:order => "created_at desc",:conditions => ["title like ? " , "%#{params[:search]}%"])


 end

  def new
    
  end
  def destroy
    Paper.find(params[:id]).destroy
    redirect_to "/papers"
  end


  def show
    @paper=Paper.find(params[:id])
    @blocks= @paper.paper_blocks
  end

  
  def create
    Paper.create(:paper_category_id=>"1",:title=>params[:paper][:paper_title],:description=>params[:paper][:paper_describe],:creater_id=>"#{User.find_by_name(cookies[:user_name]).id}",:total_score=>params[:paper][:paper_total_score],:total_question_num=>params[:paper][:paper_total_question_num])

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
    PaperBlock.create(:paper_id=>params[:module][:paper_id],:title=>params[:module][:title],:description=>params[:module][:description])
    redirect_to "/papers/#{params[:module][:paper_id]}/new_step_two"
  end
  
  def edit

  end


end
