module Constant
    #邮箱地址
  EMAILS = {
    :e126 => ['http://www.126.com','网易126'],
    :eqq => ['http://mail.qq.com','QQ'],
    :e163 => ['http://mail.163.com','网易163'],
    :esina => ['http://mail.sina.com.cn','新浪'],
    :esohu => ['http://mail.sohu.com','搜狐'],
    :etom => ['http://mail.tom.com','TOM'],
    :esogou => ['http://mail.sogou.com','搜狗'],
    :e139 => ['http://mail.10086.cn','139手机'],
    :egmail => ['http://gmail.google.com','Gmail'],
    :ehotmail => ['http://www.hotmail.com','Hotmail'],
    :e189 => ['http://www.189.cn','189'],
    :eyahoo => ['http://mail.cn.yahoo.com','雅虎'],
    :eyou => ['http://www.eyou.com','亿邮'],
    :e21cn => ['http://mail.21cn.com','21CN'],
    :e188 => ['http://www.188.com','188财富邮'],
    :eyeah => ['http://www.yeah.net','网易Yeah.net'],
    :efoxmail => ['http://www.foxmail.com','foxmail'],
    :ewo => ['http://mail.wo.com.cn','联通手机'],
    :e263 => ['http://www.263.net','263']
  }
  #服务路径
  SERVER_PATH = "http://localhost:3000"

  #项目文件目录
  PUBLIC_PATH = "#{Rails.root}/public"
  #试卷生成路径
  PAPER_PATH = "#{PUBLIC_PATH}/papers"
  #试卷服务器访问路径
  PAPER_URL_PATH = SERVER_PATH + "/papers"
  #客户端访问试卷
  PAPER_CLIENT_PATH = SERVER_PATH + "/paperjs"
  #客户端访问答卷
  ANSWER_CLIENT_PATH = SERVER_PATH + "/result"
  #导出未确认名单路径
  UNAFFIRM_PATH = "/excels"
  #收藏文件路径
  COLLECTION_PATH = "/collections"

  RIGHTS = {
    :english_fourth_level => ["英语四级权限",1],
    :english_sixth_level => ["英语六级权限",2]
  }
  FAVOURABLE=50
  AGENCY_COST=2
end
