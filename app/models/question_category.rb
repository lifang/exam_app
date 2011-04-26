class QuestionCategory < ActiveRecord::Base
  has_many :questions
end
