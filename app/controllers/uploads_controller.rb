class UploadsController < ApplicationController
  
  def upload_images
    filename = params[:nicImage].original_filename.split('.').reverse
    @filename = "/upload_images/" + Time.now.strftime("%Y%m%d%H%M%S") + '.' + filename[0]
    File.open("#{File.expand_path(Rails.root)}/public#{@filename}", "wb") do |f|
      f.write(params[:nicImage].read)
    end
    render :layout => false#, :inline => "<script>document.getElementById('pic_url').value='"+ @filename +"';</script>"
  end

  def upload
  end


end
