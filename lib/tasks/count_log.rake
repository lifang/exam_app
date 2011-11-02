# encoding: utf-8
require 'rexml/document'
include REXML
require 'spreadsheet'

namespace :count_log do
  desc "count_log"
  task(:excel => :environment) do
    url="#{Rails.root}/public/count_log/#{2.day.ago.strftime('%Y_%m_%d')}_count_log.xls"
    Spreadsheet.client_encoding = "UTF-8"
    new_user = User.count('id', :conditions => ["created_at >=? and created_at <=?", 1.day.ago.to_date,Time.now.to_date])
    new_vip = Order.count('id', :conditions => ["created_at >=? and created_at <=?", 1.day.ago.to_date,Time.now.to_date])
    str ="select count(ex.id) sum,ex.types from exam_users eu left join examinations ex on ex.id=eu.examination_id where eu.created_at>=? and eu.created_at <=? group by ex.types"
    info = ExamUser.find_by_sql([str,1.day.ago.to_date,Time.now.to_date])
    combine_practice,true_practice,simulate_exam=0,0,0
    info.each do |type|
      combine_practice= type.sum  if type.types==2
      true_practice= type.sum   if type.types==1
      simulate_exam= type.sum  if type.types==0
    end
    all_info=ExamUser.find_by_sql("select count(ex.id) sum,ex.types from exam_users eu left join examinations ex on ex.id=eu.examination_id group by ex.types")
    all_combine,all_true,all_simulate=0,0,0
    all_info.each do |type|
      all_combine = type.sum if type.types==2
      all_true = type.sum if type.types==1
      all_simulate = type.sum if type.types==0
    end
    if(!File.exist?(url))
      puts "create"
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      sheet.row(0).concat %w{统计时间 注册用户 升级会员 综合训练 真题训练 模拟考试}
      sheet.row(1).concat ["#{1.day.ago.strftime('%Y%m%d')}", "#{new_user}/#{User.all.count}", "#{new_vip}/#{Order.all.count}","#{combine_practice}/#{all_combine}","#{true_practice}/#{all_true}","#{simulate_exam}/#{all_simulate}"]
      book.write "#{Rails.root}/public/count_log/#{1.day.ago.strftime('%Y_%m_%d')}_count_log.xls"
    else
      puts "edit"
      old_book = Spreadsheet.open(url)
      old_sheet=old_book.worksheet 0
      row_num=0
      new_book = Spreadsheet::Workbook.new
      new_sheet = new_book.create_worksheet
      old_sheet.each do |this_row|
        new_sheet.row(row_num).concat this_row
        row_num+=1
      end
      puts row_num
      new_sheet.row(row_num).concat ["#{1.day.ago.strftime('%Y%m%d')}", "#{new_user}/#{User.all.count}", "#{new_vip}/#{Order.all.count}","#{combine_practice}/#{all_combine}","#{true_practice}/#{all_true}","#{simulate_exam}/#{all_simulate}"]
      new_book.write"#{Rails.root}/public/count_log/#{1.day.ago.strftime('%Y_%m_%d')}_count_log.xls"
    end
  end
end

