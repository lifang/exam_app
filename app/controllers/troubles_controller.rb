class TroublesController < ApplicationController
  def index
      @troubles=Trouble.all
  end
end