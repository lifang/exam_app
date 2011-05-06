class ProblemTagRelation < ActiveRecord::Base
  belongs_to:problem, :class_name =>"Problem"
  belongs_to:tag, :class_name =>"Tag"
end



