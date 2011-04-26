class QuestionTagRelation < ActiveRecord::Base
  belongs_to:question, :class_name =>"questions"
  belongs_to:tag, :class_name =>"tags"
end



