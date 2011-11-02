# encoding: utf-8
class Order< ActiveRecord::Base
  belongs_to :user
  TYPES = {:english_fourth_level => 1, :english_sixth_level => 2}  #VIP分类：四级，六级
  PAY_TYPE = {:SHARE => 0, :PAYMENT => 1, :ACCREDIT => 2}    #如何升级成vip：1分享 2付费 3授权码
  
end
