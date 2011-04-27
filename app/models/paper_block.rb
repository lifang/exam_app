class PaperBlock < ActiveRecord::Base
   has_many :block_question_relations
   belongs_to :paper
   has_many :questions,:through=>:block_question_relations,:foreign_key=>:question_id

 # BLOCK_TYPE = {:SINGLE_CHOOSE =>1, :MORE_CHOOSE =>2}
end


