# encoding: utf-8
class ReportErrorsController < ApplicationController

  def index
    @report_errors = ReportError.all.paginate(:per_page=>10,:page=>params[:page])
  end

  def destroy
    @report_error=ReportError.find(params[:id])
    @report_error.destroy
    redirect_to request.referer
  end
end


