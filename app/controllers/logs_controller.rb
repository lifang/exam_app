class LogsController < ApplicationController
  def index
  end

  def download_logs
    url = Constant::PUBLIC_PATH + Constant::LOG_PATH
    file_url = "/#{1.day.ago.strftime("%Y_%m_%d")}_count_log.xls"
    if File.exist?(url+file_url)
      render :inline => "<script>window.location.href='#{Constant::LOG_PATH}#{file_url}';</script>"
      return 0
    else
      file_url = "/#{2.day.ago.strftime("%Y_%m_%d")}_count_log.xls"
      if File.exist?(url+file_url)
        render :inline => "<script>window.location.href='#{Constant::LOG_PATH}#{file_url}';</script>"
        return 0
      else
        render :inline => "<script>alert('没有生成最新的日志');</script>"
        return 0
      end
    end
  end

end
