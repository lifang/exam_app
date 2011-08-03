# encoding: utf-8
module UsersHelper

  #取得用户对应类型的权限.如果对应值为1，则返回true；如果对应值为0，则返回false。
  #参数： value、which都为整型。 value为用户的权限值；which为value转为二进制数时对应的位置的值，1为最低位。 ---jeffrey 2011.7.18 10:30
  def check_authority(value,which)
    result=(value/(2**(which-1)))%2
    if result==0
      return false
    else
      return true
    end
  end

  #计算用户的最终权限值，即拥有的各种身份权限的总和，如学生，老师等。返回最终权限值value。
  #参数： values_array为各项身份的权限值组成的数组。  ---jeffrey 2011.7.18 11:53
  def count_authority_value(values_array)
    result = 0
    values_array.each do |value|
      result = result | value
    end
    return result
  end

  

end



  