Factory.define :user do |user|
	user.name "jeffrey"
  user.user_name "xuqiyong"
	user.email "jeffrey6052@163.com"
	user.password "hero2000"
	user.password_confirmation "hero2000"
  user.mobilephone "15371827113"
  user.address "jiangsu taizhou xinghua"
end

Factory.define :paper do |paper|
  paper.title "ruby class test examination"
  paper.types "ruby"
  paper.creater_id 1
  description "this is a test paper."
  total_score "100"
  total_question_num "25"
 
end