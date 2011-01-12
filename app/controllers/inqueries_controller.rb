# coding: utf-8
class InqueriesController < ApplicationController
  # GET /inqueries
  # GET /inqueries.xml
  # layout "public"
  layout nil
  before_filter:authorize, :except => [:public]
     
  def index

    @inqueries=Inquery.where("user_id = ?", session[:user_id]) 

    respond_to do |format|
      format.html # index.html.erb
      #  format.xml  { render :xml => @inqueries }
    end
  end

  def cargo
    @cargo=Cargo.find_by_id(params[:cargo_id])
    @inqueries=Inquery.where("cargo_id = ?", params[:cargo_id])

    respond_to do |format|
      format.html # cargo.html.erb
      format.xml  { render :xml => @inqueries }
    end
  end

  #one trucks's all baojia
  def truck
    @truck=Truck.find_by_id(params[:truck_id])
    @inqueries=Inquery.where("truck_id = ?", params[:truck_id])
    respond_to do |format|
      format.html # part.html.erb
      format.xml  { render :xml => @inqueries }
    end
  end
  
  def part
   
    unless params[:cargo_id].nil?
      @cargo=Cargo.find_by_id(params[:cargo_id])
      @inqueries=Inquery.where("cargo_id = ? AND user_id = ?", params[:cargo_id], session[:user_id])
    end

    unless params[:truck_id].nil?
      @truck=Truck.find_by_id(params[:truck_id])
      @inqueries=Inquery.where("truck_id = ? AND userb_id = ?", params[:truck_id], session[:user_id])
    end
   
    respond_to do |format|
      format.html # part.html.erb
      # format.xml  { render :xml =>@cargo }
    end
    
  end
 
  # GET /inqueries/1
  # GET /inqueries/1.xml
  def show
    @inquery = Inquery.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @inquery }
    end
  end

  # GET /inqueries/new
  # GET /inqueries/new.xml
  def new
    
    @inquery = Inquery.new
    @inquery.truck_id=params[:truck_id]
    @inquery.user_id=session[:user_id]

    @truck=Truck.find(@inquery.truck_id)

    @mycargo=Hash.new

    if params[:cargo_id].nil?
      @cargos = Cargo.where("user_id = ? AND status = ?",session[:user_id],"配车")

      @cargos.each do |cargo|
        @mycargo[cargo.cate_name+"("+cargo.fcity_name+"<=>"+cargo.tcity_name+")"]=cargo.id
      end
    else
      @cargo=Cargo.find(params[:cargo_id])
      @mycargo[@cargo.cate_name+"("+@cargo.fcity_name+"<=>"+@cargo.tcity_name+")"]=@cargo.id
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @inquery }
    end
  end

  # GET /inqueries/1/edit
  def edit
    @inquery = Inquery.find(params[:id])
    @cargos = Cargo.find(:all,:conditions=>["user_id = ?",session[:user_id]])
    @mycargo=Hash.new
    @cargos.each do |cargo|
      @mycargo[cargo.cate_name+"("+cargo.fcity_name+"<=>"+cargo.tcity_name+")"]=cargo.id
    end
  end

  # POST /inqueries
  # POST /inqueries.xml
  def create
    @inquery = Inquery.new(params[:inquery])
     if params[:mianyi]=="on"
      @inquery.price=nil
    end
     @cargo=Cargo.find(@inquery.cargo_id)
     @truck=Truck.find(@inquery.truck_id)

    @inquery.cargo_company_id=@cargo.company_id
    @inquery.cargo_user_id=@cargo.user_id
    @inquery.truck_company_id=@truck.company_id
    @inquery.truck_user_id=@truck.user_id


    respond_to do |format|
      #update statistic


      @cstatistic=Cstatistic.find(@cargo.cstatistic_id)
      total_xunjia=@cstatistic.total_xunjia || 0
      @cstatistic.update_attribute(:total_xunjia,total_xunjia+1)

      #update  tstatistic
      
      @tstatistic=Tstatistic.find(@truck.tstatistic_id)
      total_xunjia=@tstatistic.total_xunjia || 0
      @tstatistic.update_attribute(:total_xunjia,total_xunjia+1)

      if @inquery.save
        format.html { redirect_to(@inquery, :notice => 'Inquery was successfully created.') }
        format.xml  { render :xml => @inquery, :status => :created, :location => @inquery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @inquery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /inqueries/1
  # PUT /inqueries/1.xml
  def update
    @inquery = Inquery.find(params[:id])
    @truck=Truck.find_by_id(@inquery.truck_id)
    @inquery.paizhao=@truck.paizhao
    @inquery.fcity_name=@truck.fcity_name
    @inquery.tcity_name=@truck.tcity_name
    @cargos = Cargo.find(:all,:conditions=>["user_id = ?",session[:user_id]])

    @mycargo=Hash.new
    @cargos.each do |cargo|
      @mycargo[cargo.cate_name+"("+cargo.fcity_name+"<=>"+cargo.tcity_name+")"]=cargo.id
    end

    respond_to do |format|
      if @inquery.update_attributes(params[:inquery])
        format.html { redirect_to(@inquery, :notice => 'Inquery was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @inquery.errors, :status => :unprocessable_entity }
      end
    end
  end

  def request_chenjiao
     @inquery = Inquery.find(params[:id])
     #update truck status
     @truck=Truck.find(@inquery.truck_id)

     @truck.update_attribute(:status,"请求成交")

    puts "update rtuck #{@truck.id} status=请求成交"
      #update cargo status

     @cargo=Cargo.find(@inquery.cargo_id)
     @cargo.update_attribute(:status,"请求成交")

     @inquery.update_attribute(:status,"请求成交")

    #TOTO:notify all other related truck
    #All quotes to from this truck change to chenjiao
  
    @quotes=Quote.where("truck_id =? AND status =?",@truck.id,"配货")
    if  @quote.size>0
    @quotes.each do |quote|
      quote.update_attribute(:status,"过期")
    end
    end
      #All Inquers from this cargo neec change to chenjiao
       @inqueries=Inquery.where("cargo_id =? AND status =?",@cargo.id,"配货")
    if  @inqueries.size>0
      @inqueries.each do |inquery|
      inquery.update_attribute(:status,"过期")
    end
    end


     respond_to do |format|
        format.html { redirect_to(:controller=>"cargos",:action=>"index" )}
    end
    
  end

  def confirm_chenjiao
    
  end

  # DELETE /inqueries/1
  # DELETE /inqueries/1.xml
  def destroy
    @inquery = Inquery.find(params[:id])
    @inquery.destroy

    respond_to do |format|
      format.html { redirect_to(inqueries_url) }
      format.xml  { head :ok }
    end
  end
end
