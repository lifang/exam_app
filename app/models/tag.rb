class Tag < ActiveRecord::Base
  has_many :problem_tag_relations,:dependent=>:destroy
  has_many :problems,:through=>:problem_tag_relations,:foreign_key=>"problem_id"
  has_many :question_tag_relations,:dependent=>:destroy
<<<<<<< HEAD
  has_many :questions,:through=>:question_tag_relations,:foreign_key=>"question_id"

=======
  has_many :questions
>>>>>>> 8586b48705427e26e9550fc55ceae99236b7a169
end
