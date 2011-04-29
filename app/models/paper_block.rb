class PaperBlock < ActiveRecord::Base
   has_many :block_question_relations
   belongs_to :paper
   has_many :questions,:through=>:block_question_relations,:foreign_key=>:question_id

   BLOCK_TYPE = {:SINGLE_CHOSE => 0, :MORE_CHOSE =>1, :JUDGE => 2, :SINGLE_CALK => 3,
                   :MORE_CALK => 4, :COLLIGATION => 5, :CHARACTER => 6 }
                   #0 单选题； 1 多选题；2 判断题；3 填空题； 4 完型填空题； 5 综合题； 6 简答题
end


