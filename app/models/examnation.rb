class Examnation < ActiveRecord::Base
<<<<<<< HEAD
has_many:exam_plans,:dependent => :destroy
=======
  has_many:exam_plans,:dependent => :destroy
>>>>>>> e29318efc1aad037da78d5493b77a68b7df9f4e2
  belongs_to:paper,:dependent => :destroy
end
