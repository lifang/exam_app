module ApplicationHelper
  def display_flash
    if flash[:warn]
      html = "<div id='flash_notice' class='flash_warn' style='background:#fde03b; padding:8px;'>" +
        "<span title='关闭' style='float:right;cursor:pointer;' onclick=\"$('flash_notice').remove()\"><img src='/images/small-close.gif'/></span>" +
        "<img align='absmiddle' src='/images/icon_caution.gif' style='margin-right:8px;'/>#{flash[:warn]}</div><div class='clear'></div>"
      html += "<script type='text/javascript' language='javascript'>new Effect.Highlight('flash_notice');</script>"
    elsif flash[:error]
      html = "<div id='flash_notice' class='flash_error'>" +
        "<span title='关闭' style='float:right;cursor:pointer;' onclick=\"$('flash_notice').remove()\"><img src='/images/small-close.gif'/></span>" +
        "<img align='absmiddle' src='/images/icon_error.gif' style='margin-right:8px;' />#{flash[:error]}</div><div class='clear'></div>"
      html += "<script type='text/javascript' language='javascript'>new Effect.Highlight('flash_notice');</script>"
    elsif flash[:notice]
      html = "<div id='flash_notice' class='flash_notice'style='background:#129c00; padding:8px; color:#FFF;'>" +
        "<span title='关闭' style='float:right;cursor:pointer;' onclick=\"$('flash_notice').remove()\"><img src='/images/small-close.gif'/></span>" +
        "<img align='absmiddle' src='/images/icon_notice.gif' style='margin-right:8px;' />#{flash[:notice]}</div><div class='clear'></div>"
      html += "<script type='text/javascript' language='javascript'>new Effect.Highlight('flash_notice', {startcolor: '#FFF',endcolor: '#FFF'});</script>"
    elsif flash[:pic_warn]
      html = "<div id='flash_notice' class='flash_pic_warn'>" +
        "<span title='关闭' style='float:right;cursor:pointer;' onclick=\"$('#flash_notice').remove()\"><img src='/images/small-close.gif'/></span>" +
        "<img align='absmiddle' src='/images/icon_caution.gif' style='margin-right:8px;'/>#{flash[:pic_warn]}</div><div class='clear'></div>"
      html += "<script type='text/javascript' language='javascript'>new Effect.Highlight('flash_notice');</script>"
    elsif flash[:success]
      html = "<div id='flash_notice' class='flash_notice'>" +
        "<span title='关闭' style='float:right;cursor:pointer;' onclick=\"$('flash_notice').remove()\"><img src='/images/small-close.gif'/></span>" +
        "<img align='absmiddle' src='/images/icon_notice.gif' style='margin-right:8px;' />#{flash[:success]}</div><div class='clear'></div>"
      html += "<script type='text/javascript' language='javascript'>new Effect.Highlight('flash_notice', {startcolor: '#74CF89',endcolor: '#d1efd8'});</script>"
    elsif flash[:failure]
      html = "<div id='flash_notice' class='flash_warn'>" +
        "<span title='关闭' style='float:right;cursor:pointer;' onclick=\"$('flash_notice').remove()\"><img src='/images/small-close.gif'/></span>" +
        "<img align='absmiddle' src='/images/icon_caution.gif' style='margin-right:8px;'/>#{flash[:failure]}</div><div class='clear'></div>"
      html += "<script type='text/javascript' language='javascript'>new Effect.Highlight('flash_notice');</script>"
    end
    return html
  end

  def re_h(html)
    return "" if html.blank?
    html.to_s.gsub("&amp;","&").gsub("&quot;","\"" ).gsub("&gt;",">").gsub("&lt;","<" )
  end

  def use_validate_js_tooltip
    html   = javascript_include_tag "validation_cn"
    html  += javascript_include_tag "tooltips"
    html  += javascript_include_tag "prototip"
    html  += "<link rel='stylesheet' type='text/css' href='/stylesheets/validates/tooltips.css'>"
    html
  end

  # 中英文混合字符串截取
  def truncate_u(text, length = 30, truncate_string = "......")
    l=0
    char_array=text.unpack("U*")
    char_array.each_with_index do |c,i|
      l = l+ (c<127 ? 0.5 : 1)
      if l>=length
        return char_array[0..i].pack("U*")+(i<char_array.length-1 ? truncate_string : "")
      end
    end
    return text
  end

  def current_user
    User.find_by_email(session[:user_email])
  end
end
