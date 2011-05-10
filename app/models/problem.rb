class Problem < ActiveRecord::Base
  has_one:problem_tag
  belongs_to:category
  has_many:problem_tag_relations,:dependent=>:destroy
  has_many :tags,:through=>:problem_tag_relations,:foreign_key=>"tag_id"
  has_many:questions,:dependent=>:destroy

  QUESTION_TYPE = {:SINGLE_CHOSE => 0, :MORE_CHOSE =>1, :JUDGE => 2, :SINGLE_CALK => 3,
    :MORE_CALK => 4, :COLLIGATION => 5, :CHARACTER => 6 }
  #0 单选题； 1 多选题；2 判断题；3 填空题； 4 完型填空题； 5 综合题； 6 简答题

  #根据不同的类型

  #创建题目
  def Problem.create_problem(problem, *question)

  end


  #更新题目的标签
  def self.update_problem_tag(problem)
    
  end
  
end



