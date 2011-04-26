class PaperBlock < ActiveRecord::Base
   has_many :block_question_relations,:dependent => :destroy
   belongs_to :paper
   has_many :question,:through=>:block_question_relations,:foreign_key=>:question_id
end


