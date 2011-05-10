class User < ActiveRecord::Base
  has_many :user_role_relations,:dependent=>:destroy
  has_many :roles,:through=>:user_role_relations,:foreign_key=>"role_id"
  has_many:examinations,:foreign_key=>"creater_id"
  has_many:papers, :foreign_key=>"creater_id"
  default_scope :order=>'users.created_at desc'
  email_regex=/\A[\w+\.]+@[a-z\d\-.]+\.[a-z]+\z/i
	name_regex=/[a-zA-Z]{1,20}|[\u4e00-\u9fa5]{1,10}/

	#telephone_regex=/^[1-9]\d*$/
  attr_accessor :password
	attr_accessible :name,:username,:mobilephone,:address,:email,:password,:salt,:encryted_password,:password_confirmation
	validates:username,  :presence=>true,:format=>{:with=>name_regex},:length=>{:maximum=>30}
	validates:email,  :presence=>true,:uniqueness =>true,:format=>{:with=>email_regex},:length=>{:maximum=>50}
  validates:password, :confirmation=>true,:length=>{:within=>6..20}, :allow_nil => true


  STATUS = {:LOCK => 0, :NORMAL => 1} #0 未激活用户  1 已激活用户



  
	def right_password?(varnum)
    self.encrypted_password==encrypt(varnum)
  end

  #创建用户权限
  def set_role(role)
    roles << role
  end


	#before_save:encrypt_password
  
  def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end

  def self.authenticate(username, submitted_password)
    user = find_by_username(username)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  
  def encrypt_password
    self.encrypted_password=encrypt(password)
  end

  private
  def encrypt(string)
    self.salt = make_salt if new_record?
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.new.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

end



