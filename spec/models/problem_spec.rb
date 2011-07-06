require 'spec_helper'
require 'rexml/document'
include REXML

describe Problem do
  before(:each) do
    @paper = Factory.create(:paper, :paper_url => "/papers/1.xml")
    @options = {:title => "____ are you?", :types => 0}
    @colligation_options = {:title => "_____,____ can I do for you?", :types => 4}   
    @attr_arry = ["how", "what", "when", "where"]

    @question_options = {:answer=>"how", :analysis => "jiexijiexijiexi", :correct_type => 0}
    @colligation_str = "{1=>1,|,diescription=>first,|,correct_type=>3,|,answer=>Excuse me,|,attr_value=>,|,score=>5,|,analysis=>anilysis
      ,|,tag=>sdsd}||{1=>1,|,diescription=>second,|,correct_type=>0,|,problem_attr_sum=>4,|,answer=>what
      ,|,attr_value=>what;|;where;|;when;|;why;|;,|,score=>5,|,analysis=>aniliysis2,|,tag=>dsfs}||"

    @paper_block = Factory.create(:paper_block, :paper_id => @paper.id)
  end

  it "should create a new problem" do
    #测试创建普通试题
    @problem = Problem.create_problem(@paper, @options)
    Question.create_question(@problem, @question_options, @attr_arry)
    #测试创建综合题
    @colligation = Problem.create_problem(@paper, @colligation_options)
    @score_arr = Question.update_colligation_questions(@colligation, Question.colligation_questions(@colligation_str), "create")

    @colligation.update_problem_tags
    Problem.should have(2).records
    Question.should have(3).records
    ProblemTagRelation.should have(2).records
    ProblemTag.should have(1).record
  end

  it "should create a problem xml" do
    @paper.paper_url = "/papers/1.xml"
    @problem = Problem.create_problem(@paper, @options)
    @question = Question.create_question(@problem, @question_options, @attr_arry)
    @doc = Problem.open_xml(File.open("#{Rails.root}/public" + @paper.paper_url))
    @doc.to_s.should_not == "E:/work/rspec_exam_app/public/papers/1.xml"
    @doc1 = @problem.create_problem_xml(@doc, 32)
    Problem.write_xml("#{Rails.root}/public" + @paper.paper_url, @doc1)
  
    @doc.nil?.should_not be true
  end

  it "should delete a problem xml" do
    @problem = Problem.create_problem(@paper, @options)
    @question = Question.create_question(@problem, @question_options, @attr_arry)
    @doc = Problem.open_xml("#{Rails.root}/public" + @paper.paper_url)
    lambda{
      Question.delete_all(["problem_id = ?", @problem.id])
    }.should change(Question, :count).by(-1)
    lambda{
      Problem.remove_problem_xml(@doc, "paper/blocks/block[@id='#{@paper_block.id}']/problems/problem[@id='#{@problem.id}']")
      Problem.delete(@problem.id)
    }.should change(Problem, :count).by(-1)
  end


end
