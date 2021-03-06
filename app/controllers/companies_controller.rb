# coding: utf-8
class CompaniesController < ApplicationController
  # GET /companies
  # GET /companies.xml
 
  before_filter:admin_authorize,:only=>[:index] #for debug purpose
  before_filter:authorize
  protect_from_forgery :except => [:tip,:login]
  include CompaniesHelper

layout 'public'
 layout :choose_layout
  
    def choose_layout
      return 'admin'  if action_name =='admin'      
      return 'users' if action_name=="new" || action_name=="edit"
      return 'public' if action_name=="show"
     end
     
   def admin
   @companies = Company.paginate(:page=>params[:page]||1,:per_page=>20)
   end

  def index
    @company = Company.where(:user_id =>session[:user_id]).first #only one company actully
    @inquery_company=Array.new
    @quote_company=Array.new
    @companies=Array.new
    #vendor
    if params[:who]=="vendor"
      ExpiredInquery.where(:cargo_company_id =>@company.id,:status=>"已成交"||"正在成交").each do |inquery|
        @inquery_company<<inquery.truck_company_id
      end 
      
      Inquery.where(:cargo_company_id =>@company.id,:status=>"已成交"||"正在成交").each do |inquery|
        @inquery_company<<inquery.truck_company_id
      end
      
     ExpiredQuote.where(:cargo_company_id =>@company.id,:status=>"已成交"||"正在成交").each do |quote|
        @quote_company<<quote.truck_company_id
      end
      
      Quote.where(:cargo_company_id =>@company.id,:status=>"已成交"||"正在成交").each do |quote|
        @quote_company<<quote.truck_company_id
      end
      @quote_company.uniq!
      
    elsif params[:who]=="custermer"
     ExpiredInquery.where(:truck_company_id =>@company.id, :status=>"已成交").each do |inquery|
        @inquery_company<<inquery.cargo_company_id
      end
      ExpiredQuote.where(:truck_company_id =>@company.id,:status=>"已成交").each do |quote|
        @quote_company<<quote.cargo_company_id
      end
      Inquery.where(:truck_company_id =>@company.id, :status=>"已成交").each do |inquery|
        @inquery_company<<inquery.cargo_company_id
      end
      Quote.where(:truck_company_id =>@company.id,:status=>"已成交").each do |quote|
        @quote_company<<quote.cargo_company_id
      end
    @quote_company.uniq!
    else
      #this is for logined user
      @company = Company.where(:user_id =>session[:user_id]).first #only one company actully
    end

    #calculate companies
    @inquery_company.each do |company_id|
      @companies<<Company.find(company_id)
    end
      
    @quote_company.each do |company_id|
      @companies<<Company.find(company_id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])

    respond_to do |format|

      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end
   def showf
    @company = Company.find(params[:id])

    respond_to do |format|
        format.html # new.html.erb
       format.xml  { render :xml => @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new

    @company = Company.new
    if session[:user_id]
    @user=User.find(session[:user_id]) 
    @contact=UserContact.where(:user_id=>@user.id).first
    end
     if params[:who]=="personal"
       @company.ispersonal=1
     else
       @company.ispersonal=0
     end


    unless @user.blank?
    @company.user_id=@user.id
    @company.user_name=@user.name
    else
      flash[:notice]="非注册用户，不能创建公司"
      redirect_to root_path
      return 
    end

    respond_to do |format|
      if params[:who]=="personal"
        format.html {render :template=>"/companies/personalnew"}# new.html.erb
      else
      format.html # new.html.erb
      end
   
    #  format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
    
  #  if @company.fix_phone.match(/-/)
     # @company.quhao=@company.fix_phone.split(/-/)[0]
     # @company.fix_phone=@company.fix_phone.split(/-/)[1]
   # else
   #   @company.quhao=""
   #   @company.fix_phone=@company.fix_phone
  #  end
  end

  # POST /companies
  # POST /companies.xml
  def create
   # params[:company][:fix_phone]=params[:quhao]+"-"+ params[:company][:fix_phone]
    @company = Company.new(params[:company])    
     
    #ret_val_company=get_company_from_params(params)

    respond_to do |format|
      if @company.save
        #update user'company_id
        #@user=User.find(params[:company][:user_id])
        @user=User.find(session[:user_id])
        raise if @user.blank?
        @user.update_attributes({:company_id=>@company.id})


        flash[:notice] = '公司创建成功，恭喜你注册完成了'
       # session[:user_id]=@user.id
        format.html {  redirect_to root_path}
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        flash[:notice] = '公司创建失败了'
        format.html { render :action => "new",:layout=>"public" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    #params[:company][:fix_phone]=params[:quhao]+"-"+ params[:company][:fix_phone]
    @company= Company.find(params[:id])
    #company = update_company(params)

    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice] = "公司信息成功更新"
      #  format.html { redirect_to(@company) }
      format.html { render(:layout=>'public',:action=>'show') }
      format.xml  { head :ok }
      else
        flash[:notice] << " 公司信息更新失败"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  def search
    @company=Company.new
    @company.city_code=params[:companysearch][:city_code]
    @company.city_name=params[:companysearch][:city_name]
    @companies=Company.where(:city_code =>params[:companysearch][:city_code])

    respond_to do |format|

      format.html { render :layout=>'public',:action=>"index"}
        
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    respond_to do |format|
      format.html { redirect_to(companies_url) }
      format.xml  { head :ok }
    end
  end
end
