class ExamUser < ActiveRecord::Base
  belongs_to :user
  has_many :rater_user_relations,:dependent=>:destroy
  belongs_to :examination
  has_many :exam_raters,:through=>:rater_user_relations,:foreign_key=>"exam_rater_id"
  belongs_to :paper

  require 'rexml/document'
  include REXML

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
    self.paper = papers[rand(papers.length-1)]
    self.save
  end

  #组装查询成绩的sql
  def ExamUser.generate_result_sql(options={})
    sql = "select u.id u_id, e.id e_id, e.title e_title, e.description,e.start_at_time,
      c.name c_name,p.id p_id, p.total_score p_total_score,
      p.total_question_num, us.name u_name, us.email, u.started_at, u.total_score u_total_score, u.answer_sheet_url
      from exam_users u inner join examinations e on e.id = u.examination_id
      inner join papers p on p.id = u.paper_id
      inner join users us on us.id = u.user_id 

      left join categories c on c.id = p.category_id where 1=1 "
    options.each do |key, value|
      sql += " and #{key} #{value} "
    end unless options.empty?
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

  def submited!
    self.toggle!(:is_submited)
  end

  #考生更新考试时长信息
  def update_info_for_join_exam(exam_start_time = nil, exam_time)
    self.toggle!(:is_user_affiremed)
    self.started_at = Time.now
    self.ended_at = exam_start_time.nil? ? Time.now + exam_time.minutes :
      exam_start_time + exam_time.minutes unless exam_time.nil?
    self.answer_sheet_url = self.generate_answer_sheet_url(self.create_answer_xml, "result")
    self.save
  end

  #创建考生答卷
  def create_answer_xml(options = {})
    content = "<?xml version='1.0' encoding='UTF-8'?>"
    content += <<-XML
      <exam id='#{self.examination_id}'>
        <paper id='#{self.paper_id}'>
          <questions></questions>
        </paper>
      </exam>
    XML
    options.each do |key, value|
      content+="<#{key}>#{value.force_encoding('ASCII-8BIT')}</#{key}>"
    end unless options.empty?
    return content
  end

  #生成考生文件
  def generate_answer_sheet_url(str, path)
    dir = "#{Rails.root}/public"
    unless File.directory?(dir)
      Dir.mkdir(dir)
    end
    file_name = "/" + path + "/#{self.id}.xml"
    url = dir + file_name
    f=File.new(url,"w")
    f.write("#{str.force_encoding('UTF-8')}")
    f.close
    return file_name
  end

  def update_answer_url(doc, question_ids_options = {})
    questions = doc.root.elements["paper/questions"]
    questions.each_element { |q| doc.delete_element(q.xpath) }if questions.children.any?
    question_ids_options.each do |key, value|
      question = questions.add_element("question")
      question.add_attribute("id","#{key}")
      question.add_element("answer").add_text("#{value}")
    end unless question_ids_options == {}
    return doc.to_s
  end

  def open_xml
    dir = "#{Rails.root}/public"
    url = File.open(dir + self.answer_sheet_url)
    return Document.new(url)
  end

end
