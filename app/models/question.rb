class Question < ActiveRecord::Base
  belongs_to :problem
  has_many :question_tag_relations,:dependent=>:destroy
  has_many :tags,:through=>:question_tag_relations,:foreign_key=>"tag_id"

  #创建题点标签
  def self.question_tags(*tag)

  end
end
