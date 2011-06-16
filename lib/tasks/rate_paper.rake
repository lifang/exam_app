require 'rexml/document'
include REXML
namespace :paper do
  desc "rate paper"
  task(:rate => :environment) do
    exam_users = ExamUser.find_by_sql("select e.id,  
        e.total_score, e.paper_id, p.paper_url, e.answer_sheet_url, e.is_auto_rate
        from exam_users e inner join papers p on p.id = e.paper_id
        where e.is_submited = 1 and e.answer_sheet_url is not null")
    dir = "#{Rails.root}/public"
    exam_users.each do |exam_user|
      paper_xml = Document.new(File.open(dir + exam_user.paper_url))
      answer_xml = Document.new(File.open(dir + exam_user.answer_sheet_url))
      answer_xml = ExamUser.generate_user_score(answer_xml, paper_xml)
      f=File.new(dir + exam_user.answer_sheet_url,"w")
      f.write("#{answer_xml.to_s.force_encoding('UTF-8')}")
      f.close
      eu = ExamUser.find(exam_user.id)
      total_score = answer_xml.root.elements["paper"].attributes["score"].nil? ? 0
          : answer_xml.root.elements["paper"].attributes["score"].text.to_i
      eu.set_auto_rater(total_score)
    end unless exam_users.blank?
  end
end