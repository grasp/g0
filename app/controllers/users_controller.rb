# coding: utf-8
class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  #include UsersHelper
  
  layout "users",:except => [:index]

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new
    # @user =create_user(params)
    @user.name=params[:user][:name]
    @user.email=params[:user][:email]
    @user.password=params[:user][:password]
    @user.activate=rand(Time.now.to_i).to_s
    @user.status="new_register"
    
    respond_to do |format|
      if @user.save
        #send  activation mail here
        # record the session for authorize
         session[:user_id]=@user.id
         @ustatistic=Ustatistic.create(:total_stock_cargo=>0,:total_stock_truck=>0,:total_truck=>0,
          :total_cargo=>0,:total_line=>0, :total_driver=>0,:total_custermer=>0,:user_id=>@user.id);
        
        #update statistic for user
        @user.update_attributes({:ustatistic_id=>@ustatistic.id})
        # User.update({'_id'=> @user.id,:ustatistic_id=>@ustatistic.id}) # is a bug 
        begin    
          url=url_for("users#activate")
          url=url+"/#{@user.name}/#{@user.activate}"

          puts "发送邮件确认链接#{url}"
          # UserMailer.welcome_email(@user,url).deliver
          flash[:notice] = '用户创建成功，可以登录，邮箱确认邮件已发'
        rescue
          puts $@
          flash[:notice] = '邮件发送失败'
          #应该标记邮件状态，发送失败
          # @user.destroy
          format.html { render :action => "new" }
        end

        # create contact is next
        flash[:notice]="需要填写你的联系信息，以便客户能够联系你"
        format.html { redirect_to(:controller=>"user_contacts",:action=>"new",:email=>"#{@user.email}")}
        #User create fail
      else
        if User.find_by_email(params[:email])
          flash[:notice] = 'email已经存在'
        else
          flash[:notice] = '用户验证出错'
        end
        
        format.html { render :action => "new" }
        #   format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update

    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  def login
    @user = User.new
  end

  def pw_reset_request
  end

  def pwreset
    @user=User.find_by_name(params[:username])
    
    #get the user from the hash
    if  params[:password] !=  params[:password_confirmation]
      flash[:notice] = "确认密码不对，请重新输入 "
    end

    #update the password here
    @user.password=params[:password]
    flash[:notice] = "密码修改成功，请登录"   if  @user.save

    respond_to do |format|

      #redirect to login if not actived,even authenticate is pass
      format.html { redirect_to(:action=>"login") }
    end
  end


  def pw_sent_confirm

    #get user from email
    @user=User.find_by_email(params[:email])

    if @user.nil?
      respond_to do |format|
        flash[:notice] = '该 Email 不存在'
        format.html { redirect_to(:action =>"pw_reset_request") }
        format.xml  { head :ok }
      end
    else
      #sent url in  mail to user
      @user.update_attributes(:activate=>rand(Time.now.to_i).to_s)
      url=url_for(:controller=>'users',:action => 'change_password_confirm')
      url=url+"/#{@user.name}/#{@user.activate}"
      ActivateMail.deliver_sent_pw_change(url,@user.email,@user.name)
      respond_to do |format|
        flash[:notice] = "请到你的邮件收件箱，点击密码重置链接，然后重置密码"
        #redirect to login if not actived,even authenticate is pass
        format.html { redirect_to(:action=>"login") }
      end
    end
  end

  def  change_password_confirm
    @user=User.find_by_name(params[:username])
    # need check the code of activate field from the
    respond_to do |format|
      if  @user.activate!= params[:activate]
        flash[:notice] = "密码重置链接无效"
        format.html { redirect_to(:action =>"login") }
        format.xml  { head :ok }

      else

        format.html # index.html.erb
        format.xml

      end
    end
  end
  def authenticate
    session[:user_id]= nil
    result=User.authenticate( params[:email],params[:password])
    @user=result[0]
    
    #authenticate with cookie
    if params[:remember_me]=="on" && @user
      @user.update_attribute(:preference,1)
      #need store user_info into coockie
      cookies.permanent.signed[:remember_me] = [@user.id, @user.salt,1]
   
      
    elsif params[:remember_me]=="off" && @user
       @user.update_attribute(:preference,0)
       cookies.permanent.signed[:remember_me] = [@user.id, @user.salt,0]
    end

    respond_to do |format|
      # if @user.nil? || @user.status !="actived"
      if @user.nil?
        flash[:notice]="登录失败:#{result[1]}"
         format.html { redirect_to(:controller=>'users',:action=>"login")}
      else
        if @user.status !="actived"
          flash[:notice] = "请到你的邮箱去确认邮箱" if (@user.status == "new_register" )
        end
        session[:user_id]=@user.id
        #session[:user_name]=@user.name
        session[:user_email]=@user.email
        session[:original_uri]=nil
        #  format.html { redirect_to({:controller=>"cargos",:action => "public"})}
        format.html { redirect_to root_path}
      end
    end
  end

  def activate
    name=params[:name]
    code=params[:code]
    @user=User.find_by_name(name)
    if (code==@user.activate)
      #@user.status="actived"
      @user.update_attributes(:status=>"actived")
      flash[:notice] = "用户邮箱确认成功"
      respond_to do |format|
        format.html { redirect_to(:action=>"login") }
        format.xml  { head :ok }
      end
    else
      flash[:notice] = "用户激活码无效"
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def logout
    #use ajax to update user bar

    @user=User.find(session[:user_id])

   reset_session

     #authenticate with cookie

     @user.update_attributes({:preference=>"0"})
     cookies.permanent.signed[:remember_me] = [@user.id, @user.salt,0]

    respond_to do |format|
      format.html { redirect_to("/") }
    end
  end
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end

