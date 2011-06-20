class User::ExamUsersController < ApplicationController
  require 'rexml/document'
  include REXML
  def show
    exam=ExamUser.find_by_user_id_and_examination_id(params[:user_id],params[:id])
    puts "ssssssss"
    puts params[:user_id]
    puts params[:id]
    puts exam
    @doc=ExamRater.open_file("/result/#{exam.id}.xml")
    @xml=ExamUser.show_result(exam.paper_id, @doc)
  end
  
end
