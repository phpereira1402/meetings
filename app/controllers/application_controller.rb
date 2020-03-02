class ApplicationController < ActionController::Base
  before_action :set_user

  def set_user   
    begin
      cookies[:id] = current_user.id 
    rescue => ex
      cookies[:id] = 0
    end
  end
end
