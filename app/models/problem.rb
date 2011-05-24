class Problem < ActiveRecord::Base
  has_one:problem_tag
  belongs_to:category
  has_many:problem_tag_relations,:dependent=>:destroy
  has_many :tags,:through=>:problem_tag_relations,:foreign_key=>"tag_id"
  has_many:questions,:dependent=>:destroy

  require 'rexml/document'
  include REXML
  
  QUESTION_TYPE = {:SINGLE_CHOSE => 0, :MORE_CHOSE =>1, :JUDGE => 2, :SINGLE_CALK => 3,
    :COLLIGATION => 4, :CHARACTER => 5 }
  #0 单选题； 1 多选题；2 判断题；3 填空题； 4 综合题； 5 简答题

  #创建problem
  def Problem.create_problem(paper, options = {})
    options[:category_id] = paper.category_id
    return Problem.create(options)
  end

  #创建问题的xml
  def create_problem_xml(url, block_id, options = {})
    doc=Document.new(url)
    #添加问题的xml
    block = doc.root.elements["blocks"].elements["block[@id='#{block_id}']"]
    problems = block.elements["problems"]
    problem = problems.add_element("problem")
    problem.add_attribute("id","#{self.id}")
    problem.add_attribute("score","#{options[:score]}") unless options[:score].nil?
    problem.add_attribute("types", "#{self.types}")
    title = problem.add_element("title")
    title.add_text("#{self.title}")

    #添加题点xml
    questions = problem.add_element("questions")
    self.update_question_xml(questions)

    #更新模块试卷信息
    block.attributes["total_score"] = block.attributes["total_score"].to_i + options[:score]             #更新模块总分
    doc.root.attributes["total_score"] = doc.root.attributes["total_score"].to_i + options[:score]       #更新试卷总分
    block.attributes["total_num"] = block.attributes["total_num"].to_i + 1                         #更新模块总题数 +1
    doc.root.attributes["total_num"] = doc.root.attributes["total_num"].to_i + 1                   #更新试卷总题数 +1
    doc.root.elements["base_info"].elements["updated_at"].text=Time.now.strftime("%Y年%m月%d日%H时%M分")      #试卷更新时间
    
    file = File.new(url, "w+")
    file.write(doc)
    file.close
  end


  def update_problem_xml(url, problem, options = {})

  end

  #更新题目的题点内容
  def update_question_xml(questions)
    self.questions.each do |q|
      question = questions.add_element("question")
      question.add_attribute("id","#{q.id}")
      question.add_attribute("correct_type", "#{q.correct_type}")
      question.add_element("answer").add_text("#{q.answer}") unless q.answer.nil?
      question.add_element("analysis").add_text("#{q.analysis}") unless q.analysis.nil?
      question_attrs = question.add_element("questionattrs")
      question_attrs.add_text("#{q.question_attrs}") unless q.question_attrs.nil?
      tags = question.add_element("tags")
      tag_names = []
      q.tags.collect { |tag| tag_names << tag.name  }
      tags.add_text("#{tag_names.join(' ')}") unless q.tags.blank?
    end
  end

  #更新题目的标签
  def update_problem_tags
    self.tags = []
    tags_hash = {}
    self.questions.each do |question|
      question.tags.each do |tag|
        tags_hash[tag.id] = tag
      end
    end
    self.tags << tags_hash.values
  end
  
end



