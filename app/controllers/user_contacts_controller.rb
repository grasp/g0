 # coding: utf-8
class UserContactsController < ApplicationController
  # GET /contact_people
  # GET /contact_people.xml
  before_filter:authorize
  protect_from_forgery :except => [:tip,:login]
 #  layout "public"
  layout  "users",:except => [:show,:index,:showf]
  def index

   ## only do this when in admin user
   #@user_contacts = UserContact.all

    #for logined user, we only show person he created
    @user_contact = UserContact.find_by_user_id(session[:user_id])
    user_id=session[:user_id]

   # @company = Company.where("user_id =?",session[:user_id]).first #only one company actully
   
    @inquery_user=Array.new
    @quote_user=Array.new
    @user_contacts=Array.new
    @users=Array.new

    #vendor
    if params[:who]=="vendor"
      Inquery.where(:cargo_user_id =>user_id,:status=>"已成交").each do |inquery|
        @inquery_user<<inquery.truck_user_id
      end
      Quote.where(:cargo_company_id =>user_id,:status=>"已成交").each do |quote|
        @quote_user<<quote.truck_user_id
      end

    elsif params[:who]=="custermer"
      Inquery.where("truck_user_id =? and status=?",user_id,"已成交").each do |inquery|
        @inquery_user<<inquery.cargo_user_id
      end

      Quote.where("truck_user_id =? and status=?",user_id,"已成交").each do |quote|
        @quote_user<<quote.cargo_user_id
      end

    else
      #this is for logined user
      @user_contacts = Company.where(:user_id =>session[:user_id]).first #only one company actully
    end

    #calculate users
    @inquery_user.each do |user_id|
      @users<<User.find(user_id)
    end

    @quote_user.each do |user_id|
      @users<<User.find(user_id)
    end

    @users.each do |user|
    @user_contacts<<UserContact.find(user.user_contact_id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml =>@user_contact }
    end
  end

  # GET /contact_people/1
  # GET /contact_people/1.xml
  def show
    if params[:user_id]
     @user_contact = UserContact.find_by_user_id(params[:user_id])
    else
    @user_contact = UserContact.find(params[:id])
     end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_contact }
    end
  end
    def showf
    if params[:user_id]
     @user_contact = UserContact.find_by_user_id(params[:user_id])
    else
    @user_contact = UserContact.find(params[:id])
     end
    respond_to do |format|
      format.html # showf.html.erb
      format.xml  { render :xml => @user_contact }
    end
  end

  # GET /contact_people/new
  # GET /contact_people/new.xml
  def new

    unless session[:user_id]
     flash[:notice]="非法创建，请注册或者登录后添加"
     redirect_to root_path
    end
    
    
    #if already exsit , do nothing
   if UserContact.find_by_user_id(session[:user_id]).nil?
    @user=User.find(session[:user_id])
    @user_contact = UserContact.new
    @user_contact.email=@user.email

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_contact }
    end
   else
     flash[:notice]="用户联系方式已经创建"
     redirect_to root_path
   end
  end

  # GET /contact_people/1/edit
  def edit
       unless params[:id].nil?
          @user_contact= UserContact.find_by_id(params[:id])
    else
      @user_contact=UserContact.where(:name =>session[:user_name],:email =>session[:user_email]).first
      @user_contact.name=session[:user_name]
      @user_contact.email=session[:user_email]
      @user_contact.group="001"  #what is this for????
    end
  end

  # POST /contact_people
  # POST /contact_people.xml
  def create
     params[:usercontact][:user_id]=session[:user_id]
     @user_contact = UserContact.new(params[:usercontact])
    respond_to do |format|
      if @user_contact.save
        flash[:notice] = '成功创建了联系人,还需要创建你的公司'
         format.html { redirect_to(:controller=>"companies",:action=>"new")}
      else
        flash[:notice] = '创建联系人失败'
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contact_people/1
  # PUT /contact_people/1.xml
  def update
    @user_contact=UserContact.find(params[:id])
    @user_contact = update_contact_from_param(params)
    #update for myself
    if @user_contact.user_id==session[:user_id]
      @user=User.find_by_id(@user_contact.user_id)
      @user.update_attribute(:name,@user_contact.name)
      @user.update_attribute(:contact_id,@user_contact.id)
    end

    respond_to do |format|
      if @user_contact
        flash[:notice] ="成功更新了联系人#{@user_contact.name}"
        format.html { render :action => "show"  }
        format.xml  { head :ok }
      else
         flash[:notice] ="更新联系人失败"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_people/1
  # DELETE /contact_people/1.xml
  def destroy
    @user_contact = UserContact.find(params[:id])
    @user_contact.destroy

    respond_to do |format|
      format.html { redirect_to(contact_people_url) }
      format.xml  { head :ok }
    end
  end
end
