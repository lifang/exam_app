class Feedback < ActiveRecord::Base
  belongs_to:user
  belongs_to:question
  STATUS = {:SOLVED => 1}
end