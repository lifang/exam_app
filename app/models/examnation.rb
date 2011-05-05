class Examnation < ActiveRecord::Base
  has_many :examintion_paper_relations,:dependent => :destroy
  has_one :score_level
  has_many :exam_users
  belongs_to :paper,:dependent => :destroy
  belongs_to :user

end
