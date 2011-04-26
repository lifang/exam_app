class Examnation < ActiveRecord::Base
  has_many:exam_plan,:dependent => :destroy
  belongs_to:paper,:dependent => :destroy
end
