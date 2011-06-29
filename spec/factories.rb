Factory.define :user do |user|
	user.name "jeffrey"
  user.username "xuqiyong"
	user.email "jeffrey6052@163.com"
	user.password "hero2000"
	user.password_confirmation "hero2000"
  user.mobilephone "15371827113"
  user.address "jiangsu taizhou xinghua"
end

Factory.define :category do |category|
  category.name "english"
  category.parent_id 0
end


Factory.define :paper do |paper|
  paper.title "ruby class test examination"
  paper.category_id 1
  paper.creater_id 1
  paper.description "this is a test paper."
  paper.total_score 100
  paper.total_question_num 25
  paper.is_used 0
 
end

Factory.define :paper_block do |paper_block|
  paper_block.title "single choose"
  paper_block.description "single choose"
end

Factory.define :examination do |examination|
  examination.title "examination test"
  examination.description "examination description"
  examination.is_score_open 1
  examination.is_paper_open 1
  examination.is_published 1
  examination.user_affirm 0
  examination.status 2
end
