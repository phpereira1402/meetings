class ApplicationController < ActionController::Base
  before_action :set_user

  def set_user    
    cookies[:id] = @current_user.id if session[:user_id]
  end
end
