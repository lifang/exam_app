class Question < ActiveRecord::Base
  belongs_to :problem
  has_many :question_tag_relations,:dependent=>:destroy
  has_many :tags,:through=>:question_tag_relations,:foreign_key=>"tag_id"

  #创建题点
  def Question.create_question(problem, options = {}, attr_array = [])
    options[:problem_id] = problem.id
    options[:question_attrs] = attr_array.join(";-;") if attr_array.any?
    return Question.create(options)
  end

  #创建题点标签
  def question_tags(tags)
    tags.each do |tag|
      if !self.tags.include?(tag)
        self.tags << tag
      end
    end
  end
end
