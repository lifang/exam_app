class Examination < ActiveRecord::Base
  has_many :examintion_paper_relations,:dependent => :destroy
  has_many :papers
  has_many :score_levels
  has_many :exam_users
  belongs_to :user

end
