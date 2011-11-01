# encoding: utf-8
class Order< ActiveRecord::Base
  belongs_to :user
  TYPES = {:english_fourth_level => 1, :english_sixth_level => 2}
  
end
