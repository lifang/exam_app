require 'spec_helper'

describe ProblemsController do
  render_views
  before(:each) do
    @paper_id = 1        # 取值于 xml 文件，根据情况修改
    @block_id = 1        # 取值于 xml 文件，与上面的@paper_id取自同一文件内，根据情况修改
    @paper = Factory.create(:paper, :paper_url => "/papers/#{@paper_id}.xml")
  end
  describe "Post 'create'" do
    it "single choose test 1" do        # 默认建立
      post :create, :real_type=>0,:attr_key=>3,:attr1_value=>"attr1",:attr2_value=>"attr2",:attr3_value=>"attr3",:attr4_value=>"attr4",:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:SINGLE_CHOSE],:paper_id=>@paper_id,:title=>"single_choice test 1",:attr_sum=>4,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "single choose test 2" do        #增加选项，并建立
      post :create, :real_type=>0,:attr_key=>5,:attr1_value=>"attr1",:attr2_value=>"attr2",:attr3_value=>"attr3",:attr4_value=>"attr4",:attr5_value=>"attr5",:attr6_value=>"attr6",:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:SINGLE_CHOSE],:paper_id=>@paper_id,:title=>"single_choice test 2",:attr_sum=>6,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "single choose test 3" do       #删除选项，并建立
      post :create, :real_type=>0,:attr_key=>3,:attr2_value=>"attr2",:attr3_value=>"attr3",:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:SINGLE_CHOSE],:paper_id=>@paper_id,:title=>"single_choice test 3",:attr_sum=>4,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "single choose test 4" do       #删除并增加选项，并建立
      post :create, :real_type=>0,:attr_key=>5,:attr1_value=>"attr1",:attr4_value=>"attr4",:attr5_value=>"attr5",:attr7_value=>"attr7",:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:SINGLE_CHOSE],:paper_id=>@paper_id,:title=>"single_choice test 4",:attr_sum=>7,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "multi choose test 1" do         # 默认建立
      post :create, :real_type=>1,:attr1_key=>1,:attr3_key=>3,:attr1_value=>"attr1",:attr2_value=>"attr2",:attr3_value=>"attr3",:attr4_value=>"attr4",:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:MORE_CHOSE],:paper_id=>@paper_id,:title=>"multi_choice test 1",:attr_sum=>4,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "multi choose test 2" do         #增加选项，并建立
      post :create, :real_type=>1,:attr6_key=>6,:attr3_key=>3,:attr1_value=>"attr1",:attr2_value=>"attr2",:attr3_value=>"attr3",:attr4_value=>"attr4",:attr5_value=>"attr5",:attr6_value=>"attr6",:attr7_value=>"attr7",:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:MORE_CHOSE],:paper_id=>@paper_id,:title=>"multi_choice test 2",:attr_sum=>7,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "multi choose test 3" do         #删除选项，并建立
      post :create, :real_type=>1,:attr3_key=>3,:attr1_value=>"attr1",:attr3_value=>"attr3",:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:MORE_CHOSE],:paper_id=>@paper_id,:title=>"multi_choice test 3",:attr_sum=>4,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "multi choose test 4" do         #删除并增加选项，并建立
      post :create, :real_type=>1,:attr1_key=>1,:attr3_key=>3,:attr3_key=>7,:attr1_value=>"attr1",:attr3_value=>"attr3",:attr5_value=>"attr5",:attr7_value=>"attr7",:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:MORE_CHOSE],:paper_id=>@paper_id,:title=>"multi_choice test 4",:attr_sum=>7,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "judge test 1" do         # 判断题测试
      post :create, :real_type=>2,:attr_key=>1,:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:JUDGE],:paper_id=>@paper_id,:title=>"judge test 1",:attr_sum=>2,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "fill blank" do           # 填空题测试
      post :create, :real_type=>3,:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:SINGLE_CALK],:paper_id=>@paper_id,:title=>"fill blank test 1",:answer=>"i don't know.",:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "character" do            # 简答题测试
      post :create, :real_type=>5,:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:CHARACTER],:paper_id=>@paper_id,:title=>"character 1",:answer=>"i don't know.",:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
  end

  describe "Post 'update problem'" do

    it "update_single_choice" do
      @problem_id=1
      @question_id=1
      @xpath="/paper/blocks/block/problems/problem[#{@problem_id}]"
      post :update_problem, :real_type=>0,:id=>@problem_id,:attr_key=>1,:attr1_value=>"attr1",:attr2_value=>"attr2",:attr3_value=>"attr3",:attr4_value=>"attr4",:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:SINGLE_CHOSE],:paper_id=>@paper_id,:question_id=>@question_id,:title=>"single_choice update 1",:problem_id=>@problem_id,:problem_xpath=>@xpath,:attr_sum=>4,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end
    it "update_multi_choice" do
      @problem_id=4
      @question_id=4
      @xpath="/paper/blocks/block/problems/problem[#{@problem_id}]"
      post :update_problem, :real_type=>1,:id=>@problem_id,:attr2_key=>2,:attr1_value=>"attr1",:attr2_value=>"attr2",:attr3_value=>"attr3",:attr4_value=>"attr4",:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:MORE_CHOSE],:paper_id=>@paper_id,:question_id=>@question_id,:title=>"multi_choice update 1",:problem_id=>@problem_id,:problem_xpath=>@xpath,:attr_sum=>4,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end

    it "update_judge" do
      @problem_id=7
      @question_id=7
      @xpath="/paper/blocks/block/problems/problem[#{@problem_id}]"
      post :update_problem,:real_type=>2, :id=>@problem_id,:attr_key=>1,:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:JUDGE],:paper_id=>@paper_id,:question_id=>@question_id,:title=>"judge update 1",:problem_id=>@problem_id,:problem_xpath=>@xpath,:attr_sum=>2,:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end

    it "update_fill_blank" do
      @problem_id=7
      @question_id=7
      @xpath="/paper/blocks/block/problems/problem[#{@problem_id}]"
      post :update_problem, :real_type=>3,:id=>@problem_id,:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:SINGLE_CALK],:paper_id=>@paper_id,:question_id=>@question_id,:title=>"fill blank update 1",:problem_id=>@problem_id,:problem_xpath=>@xpath,:answer=>"jeffrey",:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end

    it "update_character" do
      @problem_id=7
      @question_id=7
      @xpath="/paper/blocks/block/problems/problem[#{@problem_id}]"
      post :update_problem, :real_type=>5,:id=>@problem_id,:problem=>{:block_id=>@block_id,:correct_type=>Problem::QUESTION_TYPE[:CHARACTER],:paper_id=>@paper_id,:question_id=>@question_id,:title=>"character update 1",:problem_id=>@problem_id,:problem_xpath=>@xpath,:answer=>"jeffrey",:score=>10,:analysis=>"abc"}
      response.should redirect_to(new_step_two_paper_path(@paper_id))
    end

  end
  
end
