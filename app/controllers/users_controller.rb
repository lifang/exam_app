class UsersController < ApplicationController
  def index
    
  end

  def new
    @user=User.new
  end

  def create
    @user=User.new(params[:user])
    if @user.save
      redirect_to "/sessions/new"
    else
      redirect_to "/users/new"
    end
  end
  def show
    @user=User.find(params[:id])
  end
  
end
