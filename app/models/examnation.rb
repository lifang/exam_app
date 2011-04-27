class Examnation < ActiveRecord::Base
  has_many :exam_plans,:dependent => :destroy
  belongs_to :paper,:dependent => :destroy
  belongs_to :user

end
