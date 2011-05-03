class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  def current_user
    User.find(cookies[:user_id])
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

end
