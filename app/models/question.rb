class Question < ActiveRecord::Base
  belongs_to :problem
  has_many :question_tag_relations,:dependent=>:destroy
  has_many :tags,:through=>:question_tag_relations,:foreign_key=>"tag_id"

  #创建题点
  def Question.create_question(problem, options = {}, attr_array = [])
    options[:problem_id] = problem.id
    options[:question_attrs] = attr_array.join(";-;") if attr_array.any?
    Question.create(options)
  end

  #更新提点
  def Question.update_question(question_id, options = {}, attr_array = [])
    question = Question.find(question_id)
    options[:question_attrs] = attr_array.join(";-;") if attr_array.any?
    question.update_attributes(options) unless options.empty?
    return question
  end

  #创建题点标签
  def question_tags(tags)
    self.tags = []
    tags.each do |tag|
      self.tags << tag
    end
  end
end
