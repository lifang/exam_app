class Feedback < ActiveRecord::Base
  belongs_to:user
  STATUS = {:SOLVED => 1}
end