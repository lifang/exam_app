# encoding: utf-8
namespace :examinations do
  desc "update examination status"
  task(:update => :environment) do
    examinations = Examination.find_by_sql("select * from examinations e where status != 2")
    examinations.each do |examination|
      puts examination.id.to_s + " update start..."
      if examination.start_at_time > Time.now
        examination.status = 1 unless examination.status == 1
      else
        if examination.exam_time.nil? or examination.exam_time == 0
          examination.status = 0
        elsif (examination.start_at_time + examination.exam_time.minutes) < Time.now
          examination.status = 3
        elsif (examination.start_at_time + examination.exam_time.minutes) > Time.now
          examination.status = 0
        end 
        examination.save
        puts examination.id.to_s + " update success..."
      end unless examination.start_at_time.nil? or examination.start_at_time == ""
    end unless examinations.blank?
  end
end