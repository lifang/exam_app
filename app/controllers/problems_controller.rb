class ProblemsController < ApplicationController
  before_filter :access?

  def create
    @paper = Paper.find(params[:problem][:paper_id].to_i)
    @problem = Problem.create_problem(@paper, {:title=>params[:problem][:title], :types => params[:real_type]})

    @attrs_array = Array.new   
    (1..params[:problem][:attr_sum].to_i).each { |i| @attrs_array << params["attr#{i}_value"] }
    answer_index = params[:attr_key]
    @question = Question.create_question(@problem,
      {:answer=>params["attr#{answer_index}_value"], :analysis => params[:problem][:analysis],
        :correct_type => params[:real_type]}, @attrs_array)
    
    if !params[:tag].nil? and params[:tag] != ""
    tag_name = params[:tag].split(" ")
    @question.question_tags(Tag.create_tag(tag_name))
    end
    @problem.update_problem_tags
    
    url = File.open "#{papers_path}/#{params[:problem][:paper_id].to_i}.xml"
    @problem.create_problem_xml(url, params[:problem][:block_id], {:score => params[:problem][:score].to_i})

    redirect_to  "/papers/#{params[:problem][:paper_id]}/new_step_two"
  end
end
