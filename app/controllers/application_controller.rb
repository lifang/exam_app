class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  def access?
    deny_access unless signed_in?
  end

  def proof_code(len)
    #    chars = ('A'..'Z').to_a + ('a'..'z').to_a
    chars = ('1'..'9').to_a
    code_array = []
    1.upto(len) {code_array << chars[rand(chars.length)]}
    return code_array.to_s
  end
  
  def proof_code()
    #    chars = ('A'..'Z').to_a + ('a'..'z').to_a

    code_array =('1'..'9').to_a.shuffle[1..6].join("")    
    return code_array.to_s
  end
  def get_text(text)
    @text=replace(text,"\n","")
    @r=replace(text,"\r","")
    @area=replace(@text,"\b","")
    @grade=@area.split("")
    return @grade
  end
end