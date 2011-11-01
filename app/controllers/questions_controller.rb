# encoding: utf-8
class QuestionsController < ApplicationController

  require 'rexml/document'
  include REXML

  def edit_question
    doc=Document.new(File.open "#{PAPER_PATH}/#{params[:paper_id].to_i}.xml")
    question = doc.elements["#{params[:xpath]}"]
    render :partial => "/common/edit_other_question", :object => question
  end

  def destroy
    @question=Question.find(params[:id])
    @question.destroy
    redirect_to request.referrer
  end

  def ajax_small_question_type
    partial=params["partial"]
    render :partial=>partial
  end

  def create_small_question
    paper_id=params["new_small_question_paper_id"]
    block_id=params["new_small_question_block_id"]
    problem_id=params["new_small_question_problem_id"]
    correct_type=params["new_small_question_type"]
    @paper = Paper.find(paper_id)
    @problem = Problem.find(problem_id)
    #打开xml
    url = File.open "#{Constant::PAPER_PATH}/#{paper_id}.xml"
    doc = Problem.open_xml(url)
    score_arr={}
    answer_question_attr = answer_text(correct_type.to_i,
      params[:problem][:attr_sum].to_i, params[:problem][:answer])
    @question = Question.create_question(@problem,
      {:description=>params[:problem][:description],:answer=>answer_question_attr[0], :analysis => params[:problem][:analysis].strip,
        :correct_type => correct_type.to_i}, answer_question_attr[1])
    #创建标签
    if !params[:tag].nil? and params[:tag].strip != ""
      tag_name = params[:tag].strip.split(" ")
      @question.question_tags(Tag.create_tag(tag_name))
    end
    
    question_ids = doc.get_elements("/paper/blocks/block[@id='#{block_id}']/problems/problem[@id='#{problem_id}']/questions//question").map{|n|n=n.attributes["id"].to_i}
    xml_score = doc.get_elements("/paper/blocks/block[@id='#{block_id}']/problems/problem[@id='#{problem_id}']/questions//question").map{|n|n=n.attributes["score"].to_i}
    question_ids.each_with_index do |question_id,index|
      score_arr[question_id]=xml_score[index]
    end
    score_arr[@question.id] = params[:problem][:score].to_f
    @problem.update_problem_tags
    #更新XML
    problem_element=doc.root.elements["blocks/block[@id='#{block_id}']/problems/problem[@id='#{problem_id}']"]
    doc = @problem.create_problem_xml(doc, block_id, problem_element, {:score => score_arr})
    doc = Problem.remove_problem_xml(doc, problem_element.xpath)
    Problem.write_xml(url, doc)
    #    render :inline=>"<script>document.write('params[:problem][:description]=#{params[:problem][:description]}<br/>params[:problem][:score]=#{params[:problem][:score]}<br/>params[:problem][:answer]=#{params[:problem][:answer]}<br/>params[:problem][:analysis]=#{params[:problem][:analysis]}<br/>params[:problem][:correct_type]=#{params[:problem][:correct_type]}<br/>params[:problem][:attr_sum]=#{params[:problem][:attr_sum]}<br/>paper_id=#{paper_id}<br/>block_id=#{block_id}<br/>problem_id=#{problem_id}<br/>correct_type=#{correct_type}<br/>');</script>"
    redirect_to request.referer
  end
  
end
