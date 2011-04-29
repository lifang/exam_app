class PapersController < ApplicationController


  def new
  end
  
  def show
    @paper=Paper.find(params[:id])
    @block1=PaperBlock.find(1)     #修改
    @block2=PaperBlock.find(2)     #修改
  end

  def create
    Paper.create(:paper_category_id=>"1",:title=>params[:paper][:paper_title],:description=>params[:paper][:paper_describe],:creater_id=>"#{User.find_by_name(cookies[:user_name]).id}",:total_score=>params[:paper][:paper_total_score],:total_question_num=>params[:paper][:paper_total_question_num])
    
    #模块1
    PaperBlock.create(:paper_id=>params[:paper][:block1_paper_id],:title=>params[:paper][:block1_title],:types=>1,:description=>params[:paper][:block1_describe],:block_total_score=>params[:paper][:block1_total_score])
    #### 题1
    Question.create(:question_category_id=>1,:title=>params[:paper][:question1_title],:types=>1,:is_used=>1)
    BlockQuestionRelation.create(:question_id=>1,:paper_block_id=>1,:score=>15)
    QuestionPoint.create(:question_id=>params[:paper][:point1_question_id],:description=>params[:paper][:point1_describe],:answer=>params[:paper][:point1_answer])
    QuestionAttr.create(:question_point_id=>params[:paper][:point1_attr1_point_id],:key=>params[:paper][:point1_attr1_key],:value=>params[:paper][:point1_attr1_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point1_attr2_point_id],:key=>params[:paper][:point1_attr2_key],:value=>params[:paper][:point1_attr2_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point1_attr3_point_id],:key=>params[:paper][:point1_attr3_key],:value=>params[:paper][:point1_attr3_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point1_attr4_point_id],:key=>params[:paper][:point1_attr4_key],:value=>params[:paper][:point1_attr4_value])
    #### 题2
    Question.create(:question_category_id=>1,:title=>params[:paper][:question2_title],:types=>1,:is_used=>1)
    BlockQuestionRelation.create(:question_id=>2,:paper_block_id=>1,:score=>15)
    QuestionPoint.create(:question_id=>params[:paper][:point2_question_id],:description=>params[:paper][:point2_describe],:answer=>params[:paper][:point2_answer])
    QuestionAttr.create(:question_point_id=>params[:paper][:point2_attr1_point_id],:key=>params[:paper][:point2_attr1_key],:value=>params[:paper][:point2_attr1_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point2_attr2_point_id],:key=>params[:paper][:point2_attr2_key],:value=>params[:paper][:point2_attr2_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point2_attr3_point_id],:key=>params[:paper][:point2_attr3_key],:value=>params[:paper][:point2_attr3_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point2_attr4_point_id],:key=>params[:paper][:point2_attr4_key],:value=>params[:paper][:point2_attr4_value])

    #模块2
    PaperBlock.create(:paper_id=>params[:paper][:block2_paper_id],:title=>params[:paper][:block2_title],:types=>1,:description=>params[:paper][:block2_describe],:block_total_score=>params[:paper][:block2_total_score])
    #### 题1
    Question.create(:question_category_id=>1,:title=>params[:paper][:question3_title],:types=>1,:is_used=>1)
    QuestionPoint.create(:question_id=>params[:paper][:point3_question_id],:description=>params[:paper][:point3_describe],:answer=>params[:paper][:point3_answer])
    BlockQuestionRelation.create(:question_id=>3,:paper_block_id=>2,:score=>15)
    QuestionAttr.create(:question_point_id=>params[:paper][:point3_attr1_point_id],:key=>params[:paper][:point3_attr1_key],:value=>params[:paper][:point3_attr1_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point3_attr2_point_id],:key=>params[:paper][:point3_attr2_key],:value=>params[:paper][:point3_attr2_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point3_attr3_point_id],:key=>params[:paper][:point3_attr3_key],:value=>params[:paper][:point3_attr3_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point3_attr4_point_id],:key=>params[:paper][:point3_attr4_key],:value=>params[:paper][:point3_attr4_value])
    #### 题2
    Question.create(:question_category_id=>1,:title=>params[:paper][:question4_title],:types=>1,:is_used=>1)
    QuestionPoint.create(:question_id=>params[:paper][:point4_question_id],:description=>params[:paper][:point4_describe],:answer=>params[:paper][:point4_answer])
    BlockQuestionRelation.create(:question_id=>4,:paper_block_id=>2,:score=>15)
    QuestionAttr.create(:question_point_id=>params[:paper][:point4_attr1_point_id],:key=>params[:paper][:point4_attr1_key],:value=>params[:paper][:point4_attr1_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point4_attr2_point_id],:key=>params[:paper][:point4_attr2_key],:value=>params[:paper][:point4_attr2_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point4_attr3_point_id],:key=>params[:paper][:point4_attr3_key],:value=>params[:paper][:point4_attr3_value])
    QuestionAttr.create(:question_point_id=>params[:paper][:point4_attr4_point_id],:key=>params[:paper][:point4_attr4_key],:value=>params[:paper][:point4_attr4_value])
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
