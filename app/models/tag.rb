class Tag < ActiveRecord::Base
  has_many :problem_tag_relations,:dependent=>:destroy
  has_many :problems,:through=>:problem_tag_relations,:foreign_key=>"problem_id"
  has_many :question_tag_relations,:dependent=>:destroy
  has_many :questions,:through=>:question_tag_relations,:foreign_key=>"question_id"
  #判断标签是否存在
  def Tag.is_exists?(*name)
    tags = Tag.find_all_by_name(*name)
    return tags.any?
    #return true or false
  end


  #创建标签
  def Tag.crate_tag(*name)
    tags = Tag.select("name").find_all_by_name(*name)
    existed_name = []
    tags.collect { |tag| existed_name << tag.name }
    (name - existed_name).each do  |n|
      Tag.create(:name => n)
    end unless (name - existed_name).blank?
  end

  
end
