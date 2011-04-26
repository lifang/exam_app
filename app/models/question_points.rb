class QuestionPoints < ActiveRecord::Base
  belongs_to :question_attr, :foreign_key => "question_point_id"
end
