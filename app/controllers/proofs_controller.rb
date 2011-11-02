# encoding: utf-8
class ProofsController < ApplicationController
  
  def index
    @proofs = Proof.find_all_by_checked("0").paginate(:per_page=>10,:page=>params[:page])
  end

  def approve_vip
    @proof=Proof.find(params[:id])
    @proof.update_attribute("checked",1)
    @order=Order.find_by_user_id(@proof.user_id)
    if @order.nil?
      Order.create(:user_id => @proof.user_id, :types => Order::TYPES[:english_fourth_level],
        :remark => "免费", :pay_type => Order::PAY_TYPE[:SHARE])
      UserMailer.congratulation_vip(@proof.user).deliver unless @proof.user.email.nil?
    else
      @order.update_attributes(:types=>Order::TYPES[:english_fourth_level],:remark=>"免费")
    end
    redirect_to request.referer
  end

  def reject_vip
    @proof=Proof.find(params[:id])
    @proof.update_attribute("checked",1)
    redirect_to request.referer
  end

end
