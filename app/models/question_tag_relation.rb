class QuestionTagRelation < ActiveRecord::Base
  belongs_to:question, :class_name =>"Question"
  belongs_to:tag, :class_name =>"Tag"
end



