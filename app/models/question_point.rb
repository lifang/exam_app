class QuestionPoint < ActiveRecord::Base
  has_many :question_attrs,:dependent=>:destroy
  belongs_to:question
end
