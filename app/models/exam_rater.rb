class ExamRater < ActiveRecord::Base
  require 'rexml/document'
  include REXML
  has_many :rater_user_relations,:dependent => :destroy
  has_many :exam_users, :through=>:rater_user_relations, :foreign_key => "exam_user_id"
  belongs_to :examination
  #
  #  email_regex=/\A[\w+\.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #	name_regex=/[a-zA-Z]{1,20}|[\u4e00-\u9fa5]{1,10}/
  #	#mobilephone_regex=/^[1-9]\d*$/
  #
  #  validates :name,:presence=>true,:format=>{:with=>name_regex},:length=>{:maximum=>30}
  #  validates :email,:presence=>true,:uniqueness=>true,:format=>{:with=>email_regex},:length=>{:maximum=>50}
  
  def ExamRater.open_file(url)
    file=File.open("#{Rails.root}/public"+url)
    return Document.new(file).root
  end
  def self.check_rater(info,id)
    rater_info=""
    hash =ExamUser.get_email(info)
    raters = ExamRater.find_by_sql(["select * from exam_raters r where r.email in (?) and r.examination_id=#{id}",hash.keys])
    if raters
      raters.each do |rater|
        rater_info += rater.name + "," + rater.email + ";"
      end
    end
    return rater_info
  end
  def self.create_raters(info,examination)
    hash =ExamUser.get_email(info)
    chars = (1..9).to_a
    code_array = []
    1.upto(6) {code_array << chars[rand(chars.length)]}
    hash.each do |email|
      exam_rater=ExamRater.create(:examination_id =>examination.id , :name =>email[1][0],
        :mobilephone =>email[1][1].strip, :email =>email[0].strip, :author_code =>code_array.join(""))
#      UserMailer.rater_affirm(exam_rater,id).deliver
    end
  end

end
