class User < ActiveRecord::Base

  has_many:papers
  has_many:papers,:foreign_key=>"creater_id"
  default_scope :order=>'users.created_at desc'

  email_regex=/\A[\w+\.]+@[a-z\d\-.]+\.[a-z]+\z/i
	name_regex=/[a-zA-Z]{1,20}|[\u4e00-\u9fa5]{1,10}/

	attr_accessible :name,:user_name,:telephone,:email,:password,:mobilephone,:address,:encryted_password,:password_confirmation

	validates:name,  :presence=>true,:format=>{:with=>name_regex},:length=>{:maximum=>30}


	validates:email,  :presence=>true,:uniqueness=>true,:format=>{:with=>email_regex},:length=>{:maximum=>50}
  validates:password, :presence=>true,:confirmation=>true,:length=>{:within=>6..20}
  
before_save :encrypt_password

	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

	private
	def encrypt_password
		self.salt = make_salt if new_record?
		self.encrypted_password = encrypt(self.password)
	end

	def encrypt(string)
		secure_hash("#{salt}--#{string}")
	end

	def make_salt
		secure_hash("#{Time.new.utc}--#{password}")
	end

	def secure_hash(string)
		Digest::SHA2.hexdigest(string)
	end




end
