Factory.define :user do |user|
	user.name "jeffrey"
  user.username "xuqiyong"
	user.email "jeffrey6052@163.com"
	user.password "hero2000"
	user.password_confirmation "hero2000"
  user.mobilephone "15371827113"
  user.address "jiangsu taizhou xinghua"
  user.active_code "176352"
   user.status 1
end

Factory.define :paper do |paper|
  paper.title "ruby class test examination"
  paper.creater_id 1
  paper.description "this is a test paper."
  paper.total_score "100"
  paper.total_question_num "25"
 
end
Factory.define :exam_rater do |rater|
	rater.name "qianjun"
	rater.email "er6788@126.com"
  rater.mobilephone "11111111111"
  rater.author_code "654916"
  rater.examination_id 1
end
Factory.define :examination do |examination|
	examination.creater_id 1
	examination.description "ssddd"
  examination.title "sssssssss"
  examination.status 1
  examination.user_affirm 1
end
Factory.define :exam_user do |exam_user|
  exam_user.examination_id 1
  exam_user.user_id 1
  exam_user.password "123456"
  exam_user.paper_id 1
  exam_user.is_user_affiremed 0
  exam_user.answer_sheet_url "/result/155.xml"
  exam_user.is_auto_rate 1
end
Factory.define :rater_user_relation do |exam_relation|
  exam_relation.exam_rater_id 1
  exam_relation.exam_user_id 155
  exam_relation.is_marked 0
end