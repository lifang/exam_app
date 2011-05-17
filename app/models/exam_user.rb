class ExamUser < ActiveRecord::Base
  belongs_to :user
  has_many :rater_user_relations,:dependent=>:destroy
  belongs_to :examination
  has_many :exam_raters,:through=>:rater_user_relations,:foreign_key=>"exam_rater_id"
  belongs_to:paper

  #显示单场考试的所有的考生
  def ExamUser.select_exam_users(examination)
    return Examination.find_by_sql(["select e.examination_id, e.user_id, e.is_user_affiremed, e.is_submited,
        e.open_to_user, e.answer_sheet_url, u.name, u.mobilephone, u.email
        from exam_users e inner join users u on u.id = e.user_id
        where e.examination_id = ?", examination.id])
  end

end
