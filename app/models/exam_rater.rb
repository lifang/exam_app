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

end
