class Examination < ActiveRecord::Base
  has_many :examination_paper_relations,:dependent => :destroy
  has_many :papers,:through=>:examination_paper_relations, :source => :paper
  has_many :score_levels,:dependent=>:destroy
  belongs_to :user,:foreign_key=>"creater_id"
  has_many :exam_users,:dependent => :destroy
  has_many :exam_raters,:dependent => :destroy

  STATUS = {:EXAMING => 0, :LOCK => 1, :GOING => 2,  :CLOSED => 3 } #考试的状态：0 考试中 1 未开始 2 进行中 3 已结束
  IS_PUBLISHED = {:NEVER => 0, :ALREADY => 1} #是否发布  0 没有 1 已经发布

  default_scope :order => "examinations.created_at desc"
  require 'spreadsheet'

  #创建考试
  def update_examination(attr_hash)
    attr_hash[:is_published] = IS_PUBLISHED[:NEVER] 
    unless attr_hash[:generate_exam_pwd].nil?
      generate_exam_pwd(attr_hash) if attr_hash[:generate_exam_pwd]
      attr_hash.delete(:generate_exam_pwd)
    end
    self.update_attributes(attr_hash)
    self.publish!
    #return examination
  end

  def generate_exam_pwd(attr_hash)
    attr_hash[:exam_password1] = proof_code(6)
    attr_hash[:exam_password2] = proof_code(6)
  end


  #发布考试
  def publish!
    self.toggle!(:is_published)
  end

  #修改试卷
  #此方法用来修改考试试卷，update_flag 是传过来增加或删除的标记，*paper是试卷数组
  def update_paper(update_flag, papers)
    if update_flag == "create"
      papers.each do |i|
        self.papers << i
        i.set_paper_used!
      end
    else
      if papers.size > 1
        papers.each { |i| self.papers.delete(i) }
      else
        self.papers.delete(papers)
      end
    end
  end

  def Examination.search_method(user_id, start_at, end_at, title, pre_page, page)
    sql = "select * from examinations e where creater_id = #{user_id} and is_published = 1 "
    sql += "and e.created_at >= '#{start_at}' " unless start_at.nil?
    sql += "and e.created_at <= '#{end_at}' " unless end_at.nil?
    sql += "and e.title like '%#{title}%' " unless title.nil?
    sql += "order by status asc, e.created_at desc "
    puts sql
    return Examination.paginate_by_sql(sql, :per_page =>pre_page, :page => page)
  end

  def update_score_level(score_array)
    self.score_levels = []
    0.step(score_array.length-1, 2) do |i|
      ScoreLevel.create(:examination_id=>self.id,:key=>score_array[i],:value=>score_array[i+1])
    end
  end

  def proof_code(len)
    #    chars = ('A'..'Z').to_a + ('a'..'z').to_a
    chars = (1..9).to_a
    code_array = []
    1.upto(len) {code_array << chars[rand(chars.length)]}
    return code_array.join("")
  end

  #显示单个登录考生能看到的所有的考试
  def Examination.return_examinations(user_id, examination_id = nil)
    sql = "select e.*, eu.id exam_user_id, eu.paper_id, eu.started_at, eu.ended_at, eu.is_submited from examinations e
          inner join exam_users eu on e.id = eu.examination_id
          where eu.user_id = #{user_id} and e.is_published = 1 "
    if !examination_id.nil? and examination_id != ""
      sql += " and e.id = #{examination_id}"
    end
    Examination.find_by_sql(sql)
  end

  #检验当前当前考生是否能考本场考试
  def Examination.can_answer(user_id, examination_id)
    str = ""
    examination = Examination.return_examinations(user_id, examination_id)
    if examination.any?
      if !examination[0].is_submited.nil? and examination[0].is_submited == 1
        str = "您已经交卷。" 
      else
        if examination[0].start_at_time > Time.now
          str = "本场考试开始时间为#{examination[0].start_at_time.strftime("%Y-%m-%d %H:%M:%S")},请您做好准备。"
        elsif (examination[0].start_at_time + examination[0].exam_time.minutes) < Time.now
          str = "本场考试已经结束。"
        elsif examination[0].start_end_time  < Time.now
          str = "您不能入场，本场考试入场时间为#{examination[0].start_at_time.strftime("%Y-%m-%d %H:%M:%S")}
              -#{examination[0].start_end_time.strftime("%Y-%m-%d %H:%M:%S")}。"
        end if examination[0].start_at_time
      end
    else
      str = "本场考试已经取消，或者您不是当前考试的考生。"
    end
    return [str, examination]
  end

  #导出当前考试未确认的考生名单
  def self.export_user_unaffirm(url, examination_id)
    Spreadsheet.client_encoding = "UTF-8"
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).concat %w{姓名 手机号 邮箱}
    exam_users = ExamUser.find_by_sql("select u.name, u.mobilephone, u.email from exam_users e
        inner join users u on e.user_id = u.id
        where examination_id=#{examination_id} and is_user_affiremed != 1")
    exam_users.each_with_index do |exam_user, index|
      sheet.row(index+1).concat ["#{exam_user.name}", "#{exam_user.mobilephone}", "#{exam_user.email}"]
    end   
    book.write url 
  end


end
