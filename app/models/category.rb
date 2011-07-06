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

  #用树形的方式列出分类
  def Category.category_tree
    all_categories = Category.all(:order => "name")
    @categories = Category.get_all_children(Category.category_map(all_categories),nil)
  end

  def Category.category_map(categories)
    category_hash = Hash.new
    for category in categories
      if category.parent_id != 0
        parent_id = category.parent_id
      else
        parent_id = 0
      end
      tree = category_hash[parent_id]
      if tree == nil
        tree = []
        category_hash[parent_id] = tree
      end
      tree << category
    end
    return category_hash
  end

  def Category.get_all_children(category_hash, parent)
    category_list = []
    if parent != nil
      parent_id = parent.id
    else
      parent_id = 0
    end
    children_list = category_hash[parent_id]
    if children_list != nil
      for category in children_list
        category_list << category
        category_list += get_all_children(category_hash, category)
      end
    end
    return category_list
  end

  def Category.level(category)
    if (category.parent_id == 0)
      level = 0
    else
      level = Category.level(Category.find(category.parent_id)) + 1
    end
    return level
  end

  def is_have_son?
    return Category.find_all_by_parent_id(self.id).any?
  end

end









