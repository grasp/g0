# coding: utf-8
class TrucksController < ApplicationController
  # GET /trucks
  # GET /trucks.xml

  include TrucksHelper
  before_filter:authorize, :except => [:search]
  protect_from_forgery :except => [:tip,:login]
  # layout "public"
  layout nil

  def public
    @trucks =  Truck.all(:user_id =>session[:user_id])
    render :template => 'trucks/public/index'
  end

  def index
    unless params[:id].nil?
      @stock_truck=StockTruck.find_by_id(params[:id])
    end
    unless @stock_truck.nil?
      @trucks = Truck.where({:user_id =>session[:user_id], :stock_truck_id=>params[:id]}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
    else
      unless params[:status].blank?
        @trucks = Truck.where({:user_id =>session[:user_id], :status =>params[:status]}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
      else
        @trucks = Truck.where(:user_id =>session[:user_id]).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trucks }
    end
  end

  def search
     @search=Search.new
   if params[:search].nil? then
    puts "params[:search] is nil"
    @search.fcity_name="全国"
    @search.tcity_name="全国"
    @search.fcity_code="100000000000"
    @search.tcity_code="100000000000"
   else
    @search.fcity_name=params[:search][:fcity_name]
    @search.tcity_name=params[:search][:tcity_name]
    @search.fcity_code=params[:search][:fcity_code]
    @search.tcity_code=params[:search][:tcity_code]
   end

 if @search.fcity_code=="100000000000" && @search.tcity_code=="100000000000" then
    @trucks=Truck.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)

   elsif @search.fcity_code=="100000000000" && @search.tcity_code!="100000000000"
     @trucks=Truck.where(:tcity_code =>@search.tcity_code).order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
      elsif params[:search][:tcity_code]=="100000000000" && params[:search][:fcity_code]!="100000000000"
     @trucks=Truck.where(:fcity_code =>@search.fcity_code).order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
   else
     @trucks=Truck.where({:tcity_code =>@search.tcity_code,:fcity_code =>@search.fcity_code}).order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
    end
    @search.save
  end
  
  def part
    @stock_truck=StockTruck.find_by_id(params[:stock_truck_id])
    @trucks=Truck.where(:stock_truck_id =>params[:stock_truck_id],:user_id =>session[:user_id]).paginate(:page=>params[:page]||1,:per_page=>10)
    respond_to do |format|
      format.html # part.html.erb
      format.xml  { render :xml => @cargos }
    end
  end

  def match
    @truck = Truck.find_by_id(params[:truck_id])
    @cargos=Cargo.where(:fcity_code =>@truck.fcity_code,:tcity_code =>@truck.tcity_code).paginate(:page=>params[:page]||1,:per_page=>10)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @truck }
    end
  end

  # GET /trucks/1
  # GET /trucks/1.xml
  def show
    
    @truck = Truck.find(params[:id])
    @line_ad=LineAd.find_by_line(get_line(@truck.fcity_code,@truck.tcity_code))
    
    if @line_ad.nil?
     # @line_ad=LineAd.find_by_line("0")
     # @line_ad.fcity_name=@truck.fcity_name
     # @line_ad.tcity_name=@truck.tcity_name
    end
    
    @user_contact=UserContact.find_by_id(@truck.user_id)
    @company=Company.find_by_id(@truck.company_id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @truck }
    end
  end

  # GET /trucks/new
  # GET /trucks/new.xml
  def new
    @stock_truck=StockTruck.find_by_id(params[:id])    
    @truck = Truck.new
    @user=User.find_by_id(session[:user_id])
    @user_contact=UserContact.find_by_user_id(@user.id)
    @company=Company.find_by_user_id(@user.id)
    
    @truck.stock_truck_id=@stock_truck.id
    @truck.paizhao=@stock_truck.paizhao
    @truck.dunwei=@stock_truck.dun_wei
    @truck.length=@stock_truck.che_length
    @truck.usage=@stock_truck.truck_usage
    @truck.shape=@stock_truck.truck_shape
    @truck.driver_name=@stock_truck.driver_name
    @truck.driver_phone=@stock_truck.driver_phone
    @truck.car_phone=@stock_truck.car_phone
    @truck.status="配货"


    @truck.user_id=@stock_truck.user_id
    @truck.company_id=@stock_truck.company_id
    @truck.user_contact_id=UserContact.find_by_user_id(@truck.user_id).id
   
     @user_contact=UserContact.find_by_user_id(session[:user_id])
     @truck.user_contact_id=@user_contact.id unless @user_contact.nil?

    if @user_contact.blank?
      flash[:notice]="发布车源必须要知道你的联系方式和姓名."
      render(:template=>"shared/new_contact")
      return;
    end
    @company=Company.find_by_user_id(@user.id)
    @truck.company_id=@company.id unless @company.nil?

    if @company.blank?
      flash[:notice]="你的公司信息没有填写"
      render(:template=>"shared/new_company")
      return;
    end
   
    respond_to do |format|
          format.html # new.html.erb
          format.xml  { render :xml => @truck }
        end

  end

  # GET /trucks/1/edit
  def edit
    @truck = Truck.find(params[:id])
    @stock_truck=StockTruck.find_by_id(@truck.stock_truck_id)
  end

  # POST /trucks
  # POST /trucks.xml
  def create

    # @truck= get_truck_info_from_params(params)
    @truck=Truck.new(params[:truck])
    @truck.line=@truck.fcity_code+"#"+@truck.tcity_code     

    respond_to do |format|
      if @truck.save
        flash[:notice] = '车源创建成功'
        @tstatistic=Tstatistic.create(:total_baojia=>0,:total_xunjia=>0,:total_match=>0,
          :total_click=>0,:user_id=>session[:user_id]);
        #update statistic for truck
        @truck.update_attributes({:tstatistic_id=>@tstatistic.id})
        @ustatistic=Ustatistic.find_by_user_id(session[:user_id])
        total_truck=@ustatistic.total_truck || 0
        @ustatistic.update_attributes({:total_truck=>total_truck+1})

        #update line statistic
        #update lstastistic info
        @lstatistic=Lstatistic.find_by_line(@truck.line)
        if @lstatistic.nil?
        Lstatistic.create(:line=>@truck.line,:valid_cargo=>0,:valid_truck=>1,:total_cargo=>0,:total_truck=>1)
        else
          @lstatistic.update_attributes(:valid_truck=>(@lstatistic.valid_truck ||0)+1,:total_truck=>(@lstatistic.total_truck ||0)+1)
        end

        #update stocktruck status
        @stock_truck=StockTruck.find(@truck.stock_truck_id)            
        StockTruck.collection.update({"_id" => @stock_truck.id}, {:status=>"配货"},{"$inc" => {"truckcount" => 1}})  
        
        format.html { redirect_to(@truck) }
        format.xml  { render :xml => @truck, :status => :created, :location => @truck }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @truck.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trucks/1
  # PUT /trucks/1.xml
  def update
    @truck = Truck.find(params[:id])
    @stock_truck=StockTruck.find_by_id(@truck.stock_truck_id)
    #  @trucks = update_truck_info_from_params(params)    
    respond_to do |format|
      if @truck.update_attributes( params[:truck])
        flash[:notice] = '货源更新成功.'
        format.html { redirect_to(@trucks) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trucks.errors, :status => :unprocessable_entity }
      end
    end
  end
  def confirm_chenjiao
     @truck = Truck.find(params[:id])
     
    #find quote or inquery
    @quote=Quote.where(:truck_id=>@truck.id,:status=>"请求成交").first #should be only one
    @inquery=Inquery.where(:truck_id=>@truck.id , status=>"请求成交").first#should be only one

  
    #change truck status to 已成交
    @truck.update_attributes(:status=>"已成交")
    @quote.update_attributes(:status=>"已成交") unless @quote.blank?
    @inquery.update_attributes(:status=>"已成交") unless @inquery.blank?

    #need update statistics

         respond_to do |format|
        format.html { redirect_to(:controller=>"trucks",:action=>"index" )}
    end


  end
  # DELETE /trucks/1
  # DELETE /trucks/1.xml
  def destroy
    @truck = Truck.find(params[:id])
    @truck.destroy

    respond_to do |format|
      format.html { redirect_to(trucks_url) }
      format.xml  { head :ok }
    end
  end
end
