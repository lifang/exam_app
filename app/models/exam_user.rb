class ExamUser < ActiveRecord::Base
  belongs_to :user
  has_many :rater_user_relations,:dependent=>:destroy
  belongs_to :examination
  has_many :exam_raters,:through=>:rater_user_relations,:foreign_key=>"exam_rater_id"
  belongs_to:paper

  IS_USER_AFFIREMED = {:YES => 1, :NO => 0} #用户是否确认  1 已确认 0 未确认
  default_scope :order => "exam_users.total_score desc"

  #分页显示单场考试的所有成绩
  def ExamUser.paginate_exam_user(examination_id, pre_page, page, options={})
    sql = ExamUser.generate_sql(examination_id, options)
    return Examination.paginate_by_sql(sql, :per_page =>pre_page, :page => page)
  end
  

  #显示单场考试的所有的考生
  def ExamUser.select_exam_users(examination_id, options={})
    sql = generate_sql(examination_id, options)
    return Examination.find_by_sql(sql)
  end

  
  #组装查询学生的sql语句
  def ExamUser.generate_sql(examination_id, options={})
    sql = "select e.examination_id, e.id, e.user_id, e.is_user_affiremed, e.is_submited,
        e.open_to_user, e.answer_sheet_url, u.name, u.mobilephone, u.email, e.total_score
        from exam_users e inner join users u on u.id = e.user_id
        where e.examination_id = #{examination_id} "
    if !options.empty?
      options.each do |key, value|
        sql += " and #{key} #{value} "
      end
    end
    return sql
  end

  #随机分配学生一张试卷
  def set_paper(examination)
    papers = examination.papers
    self.paper_id = papers[rand(papers.length-1)]
    self.save
  end

  #组装查询成绩的sql
  def ExamUser.generate_result_sql(options={})
    sql = "select u.id u_id, e.id e_id, e.title e_title, e.description,e.start_at_time,c.name c_name,p.id p_id, p.total_score p_total_score,
      p.total_question_num, us.name u_name, us.email, u.started_at, u.total_score u_total_score, u.answer_sheet_url
      from exam_users u inner join examinations e on e.id = u.examination_id
      inner join papers p on p.id = u.paper_id
      inner join users us on us.id = u.user_id 
      left join categories c on c.id = p.category_id where 1=1 and e.id in (select r.examination_id from exam_users r where r.user_id=7)  "
    if !options.empty?
      options.each do |key, value|
        sql += " and #{key} #{value} "
      end
    end
    return sql
  end

  #显示单场考试的所有的考生成绩
  def ExamUser.return_exam_result(examination_id, pre_page, page)
    sql = generate_sql(examination_id)
    return ExamUser.paginate_by_sql(sql, :per_page =>pre_page, :page => page)
  end

  #显示单场考试成绩的等级
  def ExamUser.score_level_result(examination, exam_user_array)
    score_levels = examination.score_levels
    score_level_hash = {}
    exam_user_hash = {}
    score_levels.each do |score_level|
      scores = score_level.key.split("-")
      score_level_hash[score_level.value] = scores
      exam_user_hash[score_level.value] = 0
    end
    exam_user_array.each do |exam_user|
      score_level_hash.each do |key, value|
          if (exam_user.total_score >= value[0].to_i and exam_user.total_score <= value[1].to_i) or
              (exam_user.total_score <= value[0].to_i and exam_user.total_score >= value[1].to_i)
            exam_user_hash[exam_user.id] = key
            exam_user_hash[key] += 1
          end
      end
    end
    return exam_user_hash
  end
def user_affiremed
  self.toggle!(:is_user_affiremed)
end

end
