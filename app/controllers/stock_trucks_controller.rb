 # coding: utf-8
class StockTrucksController < ApplicationController
  # GET /stock_trucks
  # GET /stock_trucks.xml
  before_filter:authorize
  protect_from_forgery :except => [:tip,:login]
  include StockTrucksHelper
  #layout "public", :except => [:oper]
  layout nil
  def index
  #add for admin

   # @stock_trucks = StockTruck.all
  #  @stock_trucks = StockTruck.where("user_id = ?",session[:user_id]).order("created_at desc").paginate(:page=>params[:page]||1,:per_page=>5)
    @stock_trucks = StockTruck.where(:user_id =>session[:user_id]).sort(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>5)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_trucks }
    end
  end

  # GET /stock_trucks/1
  # GET /stock_trucks/1.xml
  def show
    @stock_truck = StockTruck.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_truck }
    end
  end

  # GET /stock_trucks/new
  # GET /stock_trucks/new.xml
  def new
    @stock_truck = StockTruck.new
    @user=User.find_by_id(session[:user_id])
    @stock_truck.user_id=@user.id
    @stock_truck.status="idle"
    @stock_truck.company_id=@user.company_id unless @user.nil?

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock_truck }
    end
  end

    def oper
    @stock_truck_id =params[:id]
     respond_to do |format|
      format.html # oper.html.erb
   #   format.xml  { render :xml => @stock_truck }
    end
  end

  # GET /stock_trucks/1/edit
  def edit
    @stock_truck = StockTruck.find(params[:id])
  end

  # POST /stock_trucks
  # POST /stock_trucks.xml
  def create
    @stock_truck = StockTruck.new(params[:stock_truck])

    respond_to do |format|
      if @stock_truck.save
        flash[:notice] = '成功创建车辆'
            @ustatistic=Ustatistic.find_by_user_id(session[:user_id])
            total_stock_truck=@ustatistic.total_stock_truck || 0
            @ustatistic.update_attribute(:total_stock_truck, total_stock_truck+1)

        format.html { redirect_to(@stock_truck) }
        format.xml  { render :xml => @stock_truck, :status => :created, :location => @stock_truck }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stock_truck.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stock_trucks/1
  # PUT /stock_trucks/1.xml
  def update
    @stock_truck = StockTruck.find(params[:id])

    respond_to do |format|
      if @stock_truck.update_attributes(params[:stock_truck])
        flash[:notice] = '成功更新了车子基本信息.'
        format.html { redirect_to(@stock_truck) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_truck.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_trucks/1
  # DELETE /stock_trucks/1.xml
  def destroy
    
    @stock_truck = StockTruck.find(params[:id])
    @stock_truck.destroy

    respond_to do |format|
      format.html { redirect_to(stock_trucks_url) }
      format.xml  { head :ok }
    end
  end
end
