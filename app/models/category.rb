class Category < ActiveRecord::Base
  has_many :problems
  has_many :papers

  #判断分类是否存在
  def Category.is_exists?(name)
    return !Category.find_by_name(name).nil?
    #return true or false
  end

  #创建分类，如存在则提示存在，不存在则创建
  def Category.is_create_category(category)

    #return true or false
  end

  
  

end









