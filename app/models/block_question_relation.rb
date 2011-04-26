class BlockQuestionRelation < ActiveRecord::Base
  belongs_to:question
  belongs_to:paper_block
 
 
end
