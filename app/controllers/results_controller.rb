class ResultsController < ApplicationController
  before_filter :access?
  
  def index

  end

  def search
    session[:email] = nil
    session[:start_at] = nil
    session[:end_at] = nil
    session[:title] = nil
    session[:email] = params[:email] if !params[:email].nil? and params[:email] != ""
    session[:start_at] = params[:start_at] if !params[:start_at].nil? and params[:start_at] != ""
    session[:end_at] = params[:end_at] if !params[:end_at].nil? and params[:end_at] != ""
    session[:title] = params[:title] if !params[:title].nil? and params[:title] != ""
    redirect_to search_list_results_path
  end

  def search_list
    sql = ExamUser.generate_result_sql
    sql += " and us.email = '#{session[:email]}'" unless session[:email].nil?
    sql += " and e.created_at >= '#{session[:start_at]}'" unless session[:start_at].nil?
    sql += " and e.created_at <= '#{session[:end_at]}'" unless session[:end_at].nil?
    sql += " and e.title like '%#{session[:title]}%'" unless session[:title].nil?
    @results = ExamUser.paginate_by_sql(sql, :pre_page => 1, :page => params[:page])
    render "index"
  end
  
end
