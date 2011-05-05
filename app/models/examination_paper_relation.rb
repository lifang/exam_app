class BlockQuestionRelation < ActiveRecord::Base
  belongs_to:paper
  belongs_to:examination

  
end

