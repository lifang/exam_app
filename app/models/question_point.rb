class QuestionPoint < ActiveRecord::Base
  has_many :question_attrs
  belongs_to:question
end
