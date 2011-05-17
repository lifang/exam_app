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


  #创建考试
  def update_examination(attr_hash)
    attr_hash[:is_published] = IS_PUBLISHED[:NEVER]
    attr_hash[:status] = STATUS[:LOCK]
    self.update_attributes(attr_hash)
    self.publish!
    return self
    #return examination
  end

  #创建考试试卷
  def self.set_papers(*paper)
   
    #return true or false
  end

  #创建考生
  def self.create_exam_users(*user)
   
    #return true or false
  end

  #创建批卷老师
  def self.create_exam_rater(*rater)

    #return true or false
  end

  #发布考试
  def publish!
    self.toggle!(:is_published)
  end

  #修改试卷
  #此方法用来修改考试试卷，update_flag 是传过来增加或删除的标记，*paper是试卷数组
  def update_paper(update_flag, papers)
    if update_flag == "create"
      if papers.size > 1
        papers.each do |i|
          self.papers << i
          i.set_paper_used!
        end
      else
        self.papers << papers
        papers.set_paper_used!
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
    sql = "select * from examinations e where creater_id = #{user_id} "
    if !start_at.nil?
      sql += "and e.created_at >= '#{start_at}' "
    end
    if !end_at.nil?
      sql += "and e.created_at <= '#{end_at}' "
    end
    if !title.nil?
      sql += "and e.title like '%#{title}%' "
    end
    sql += "order by status asc, e.created_at desc "
    puts sql
    return Examination.paginate_by_sql(sql, :per_page =>pre_page, :page => page)
  end



end
