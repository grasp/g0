 # coding: utf-8
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

   def get_line(from_code,to_code)
    if from_code<to_code
      return from_code+to_code
    elsif from_code>to_code
      return to_code+from_code
    else
      return from_code+to_code
   end
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  private
  def authorize
 if cookies.signed[:remember_me]
    #find cookie and check cookie password
   logger.debug "cookies.signed[:preference]=#{cookies.signed[:remember_me][2]}"
   logger.debug "cookies.signed[:remember_me]=#{cookies.signed[:remember_me]}"
   if(cookies.signed[:remember_me][2]==1)
    user = User.authenticated_with_token(cookies.signed[:remember_me][0],cookies.signed[:remember_me][1])
    logger.debug "authenticate with cookie}"
   end
 end
    if user
      session[:user_id]=user.id
    else

      logger.debug "authenticate with normal with session[:user_id]=#{session[:user_id]}}"

    unless User.find_by_id(session[:user_id])
      logger.debug "session not exsist"
      flash[:notice]="请登录"
      logger.debug "request url=#{request.path},root_path=#{root_path}"
     # redirect_to(:controller=>"public",:action=>"index")
      redirect_to root_path
    #else
   #   logger.debug "session already exsist"
   #   unless params[:user_id].nil?
   ##    unless (session[:user_id].to_i==(params[:user_id]).to_i)
    #     flash[:notice]="#{session[:user_id]}非法访问#{params[:user_id]}"
   #      redirect_to(:controller=>"cargos",:action=>"public")
   #    end
    #  end
   end
    end
  end

   def authorize_public

    #find cookie and check cookie password
    if cookies.signed[:remember_me]
  # logger.debug "cookies.signed[:preference]=#{cookies.signed[:remember_me][2]}"
   #logger.debug "cookies.signed[:remember_me]=#{cookies.signed[:remember_me]}"
   if(cookies.signed[:remember_me][2]==1)
    user = User.authenticated_with_token(cookies.signed[:remember_me][0],cookies.signed[:remember_me][1])
  #  logger.debug "authenticate with cookie}"
   end
    end
    if user
      session[:user_id]=user.id
    else
    #  logger.debug "authenticate with normal with session[:user_id]=#{session[:user_id]}}"
    unless User.find_by_id(session[:user_id])
   #   logger.debug "session not exsist"
    #  flash[:notice]="请先登录"
  #    logger.debug "request url=#{request.path},root_path=#{root_path}"
   
    #else
   #   logger.debug "session already exsist"
   #   unless params[:user_id].nil?
   ##    unless (session[:user_id].to_i==(params[:user_id]).to_i)
    #     flash[:notice]="#{session[:user_id]}非法访问#{params[:user_id]}"
   #      redirect_to(:controller=>"cargos",:action=>"public")
   #    end
    #  end
   end
    end
  end
end
