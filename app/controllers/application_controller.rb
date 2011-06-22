class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  include RemotePaginateHelper
  include Constant
  include UserRoleHelper
  def access?
    deny_access unless signed_in?
  end
  def write_xml(url,doc)
    file = File.new(url, "w+")
    file.write(doc)
    file.close
  end
  def proof_code(len)
    #    chars = ('A'..'Z').to_a + ('a'..'z').to_a
    chars = (1..9).to_a
    code_array = []
    1.upto(len) {code_array << chars[rand(chars.length)]}
    return code_array.join("")
  end
 
  def get_text(text)
    @text=text.gsub /['\n''\t''\b'' ']/," "
    @grade=@text.split(" ")
    return @grade
  end

  


end