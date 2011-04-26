class QuestionTagRelation < ActiveRecord::Base
  belongs_to:questions, :class_name =>"questions"
  belongs_to:tags, :class_name =>"tags"
end
