class Paper < ActiveRecord::Base
<<<<<<< HEAD
  has_many:paper_blocks ,:dependent=>:destroy
  has_many:examinations

  belongs_to:user,:foreign_key=>"creater_id"

  default_scope:order=>"id desc"
=======
  has_many :examinations, :through=>:examination_paper_realations,:foreign_key=>"examination_id"
>>>>>>> aed36d60f41360b5e7486812090d0946dca56eab
end



