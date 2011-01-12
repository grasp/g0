# coding: utf-8
class QuotesController < ApplicationController
  # GET /quotes
  # GET /quotes.xml
  #  layout "public"
  layout :nil
  before_filter:authorize, :except => [:public]
    
  def index

    unless params[:cargo_id].nil?
      @quotes =  Quote.find(:all,:conditions=>["cargo_id = ?",params[:cargo_id]])
    else
      unless params[:to].nil?
        @quotes =  Quote.find(:all,:conditions=>["userb_id = ?",session[:user_id]])
      else
        @quotes =  Quote.find(:all,:conditions=>["user_id = ?",session[:user_id]])
      end
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotes }
    end
  end


  def part
    @truck=Truck.find_by_id(params[:truck_id])
    @quotes=Quote.where("truck_id = ? AND user_id = ?", params[:truck_id], session[:user_id])

    respond_to do |format|
      format.html # part.html.erb
      format.xml  { render :xml => @cargos }
    end
  end
  #one cargo's all truck baojia
  def cargo
    @cargo=Cargo.find_by_id(params[:cargo_id])
    #only belong to me
    @quotes=Quote.where("cargo_id = ?", params[:cargo_id])

    respond_to do |format|
      format.html # cargo.html.erb
      format.xml  { render :xml => @quotes }
    end
  end

  #one trucks's all baojia
  def truck
    @truck=Truck.find_by_id(params[:truck_id])
    @quotes=Quote.where("truck_id = ? AND user_id = ?", params[:truck_id], session[:user_id])
    respond_to do |format|
      format.html # part.html.erb
      format.xml  { render :xml => @quotes }
    end
  end


  # GET /quotes/1
  # GET /quotes/1.xml
  def show
    @quote = Quote.find(params[:id])
    @cargo=Cargo.find_by_id(@quote.cargo_id)
    @trucks = Truck.find(:all,:conditions=>["user_id = ?",session[:user_id]])
    @mytruck=Hash.new
    @trucks.each do |truck|
      @mytruck[truck.paizhao]=truck.id
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quote }
    end
  end

  # GET /quotes/new
  # GET /quotes/new.xml
  def new

    @quote = Quote.new
    @cargo=Cargo.find(params[:cargo_id])
    @quote.cargo_id=@cargo.id 
    @quote.user_id=session[:user_id]
    @trucks = Truck.where("user_id = ? AND status= ?",session[:user_id],"配货")
     
    @mytruck=Hash.new

    if params[:truck_id].nil?
      @trucks = Truck.where("user_id = ? AND status = ?",session[:user_id],"配货")

      @trucks.each do |truck|
        @mytruck[truck.paizhao+"("+truck.fcity_name+"<=>"+truck.tcity_name+")"]=truck.id
      end
    else
      @truck=Truck.find(params[:truck_id])
      @mytruck[@truck.paizhao+"("+@truck.fcity_name+"<=>"+@truck.tcity_name+")"]=@truck.id
    end


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quote }
    end
  end

  # GET /quotes/1/edit
  def edit

    @quote = Quote.find(params[:id])
     
    @trucks = Truck.find(:all,:conditions=>["user_id = ?",session[:user_id]])
    @mytruck=Hash.new
    @trucks.each do |truck|
      @mytruck[truck.paizhao]=truck.id
    end
  end

  # POST /quotes
  # POST /quotes.xml

  #when multi-truck for one cargo

  def create
    @quote = Quote.new(params[:quote])

    if params[:mianyi]=="on"
      @quote.price=nil
    end

    @cargo=Cargo.find(@quote.cargo_id)
    @truck=Truck.find(@quote.truck_id)

    @quote.cargo_company_id=@cargo.company_id
    @quote.cargo_user_id=@cargo.user_id
    @quote.truck_company_id=@truck.company_id
    @quote.truck_user_id=@truck.user_id

    respond_to do |format|
      if @quote.save
        #update statistic
        @cstatistic=Cstatistic.find(@cargo.cstatistic_id)
        total_baojia=@cstatistic.total_baojia || 0
        @cstatistic.update_attribute(:total_baojia,total_baojia+1)

        #update  tstatistic
        @tstatistic=Tstatistic.find(@truck.tstatistic_id)
        total_baojia=@tstatistic.total_baojia || 0
        @tstatistic.update_attribute(:total_baojia,total_baojia+1)
    
        flash[:notice]= "创建报价成功！"
        format.html { redirect_to(@quote, :notice => 'Quote was successfully created.') }
        format.xml  { render :xml => @quote, :status => :created, :location => @quote }
      else
        flash[:notice]= "创建报价失败！" 
        format.html { render :action => "new" }
        format.xml  { render :xml => @quote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quotes/1
  # PUT /quotes/1.xml
  def update
    @quote = Quote.find(params[:id])

    respond_to do |format|
      if @quote.update_attributes(params[:quote])
        format.html { redirect_to(@quote, :notice => 'Quote was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quote.errors, :status => :unprocessable_entity }
      end
    end
  end

  def request_chenjiao

    @quote = Quote.find(params[:id])
    #update truck status
    @truck=Truck.find(@quote.truck_id)
     
    @truck.update_attribute(:status,"请求成交")
    #update cargo status

    @cargo=Cargo.find(@quote.cargo_id)
    @cargo.update_attribute(:status,"请求成交")

    @quote.update_attribute(:status,"请求成交")

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
  # DELETE /quotes/1
  # DELETE /quotes/1.xml
  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to(quotes_url) }
      format.xml  { head :ok }
    end
  end
end
