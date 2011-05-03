class PapersController < ApplicationController
<<<<<<< HEAD
before_filter :access?
 def index
    @papers=Paper.find_by_sql("select * from papers p where p.creater_id=#{cookies[:user_id]}").paginate(:per_page =>10, :page => params[:page],:order => "created_at desc",:conditions => ["title like ? " , "%#{params[:search]}%"])


 end




=======
  def index
    @papers=Paper.find_by_sql("select * from papers p where p.creater_id=#{cookies[:user_id]}").paginate(:per_page =>10, :page => params[:page],:order => "created_at desc",:conditions => ["title like ? " , "%#{params[:search]}%"])

  end

>>>>>>> 18673ba9f441a0fdc7321bec56a4b0313daafe0b
  def new
    
  end
  def destroy
    Paper.find(params[:id]).destroy
    redirect_to "/papers"
  end

<<<<<<< HEAD
=======

>>>>>>> 18673ba9f441a0fdc7321bec56a4b0313daafe0b
  def show
    @paper=Paper.find(params[:id])
    @blocks= @paper.paper_blocks
  end
<<<<<<< HEAD

  def create
    Paper.create(:paper_category_id=>"1",:title=>params[:paper][:paper_title],:description=>params[:paper][:paper_describe],:creater_id=>"#{User.find_by_name(cookies[:user_name]).id}",:total_score=>params[:paper][:paper_total_score],:total_question_num=>params[:paper][:paper_total_question_num])
  end

  def new_step_one


  




    
=======
  
  def create
    Paper.create(:paper_category_id=>"1",:title=>params[:paper][:paper_title],:description=>params[:paper][:paper_describe],:creater_id=>"#{User.find_by_name(cookies[:user_name]).id}",:total_score=>params[:paper][:paper_total_score],:total_question_num=>params[:paper][:paper_total_question_num])

>>>>>>> 18673ba9f441a0fdc7321bec56a4b0313daafe0b
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
<<<<<<< HEAD
  

  def index

    @papers=Paper.find_by_sql("select * from papers p where p.creater_id='#{cookies[:user_id]}'").paginate(:per_page =>10, :page => params[:page],:order => "created_at desc")
  end



=======

>>>>>>> 18673ba9f441a0fdc7321bec56a4b0313daafe0b
  
  def user_exist?
    if User.find_by_id(cookies[:user_id]) != current_user
      redirect_to root_path
    end
  end
<<<<<<< HEAD
  end

=======
end
>>>>>>> 18673ba9f441a0fdc7321bec56a4b0313daafe0b
