class Paper < ActiveRecord::Base
  has_many :examinations, :through=>:examination_paper_realations,:foreign_key=>"examination_id"
end
