class Category < ActiveRecord::Base
  has_many :problems
  has_many :papers
end









