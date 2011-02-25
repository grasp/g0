# coding: utf-8
class QuotesController < ApplicationController
  # GET /quotes
  # GET /quotes.xml
  #  layout "public"
  layout :nil
  before_filter:authorize, :except => [:public]
  include CargosHelper
  include TrucksHelper
  def index
    unless params[:cargo_id].nil?
      @quotes =  Quote.find(:cargo_id =>params[:cargo_id])
    else
      unless params[:to].nil?
        @quotes =  Quote.find(:userb_id =>session[:user_id])
      else
        @quotes =  Quote.find(:user_id =>session[:user_id])
      end
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotes }
    end
  end


  def part
    @truck=Truck.find_by_id(params[:truck_id])
    @quotes=Quote.where(:truck_id =>params[:truck_id], :user_id =>session[:user_id])

    respond_to do |format|
      format.html # part.html.erb
      format.xml  { render :xml => @cargos }
    end
  end
  #one cargo's all truck baojia
  def cargo
    @cargo=Cargo.find_by_id(params[:cargo_id])
    #only belong to me
    @bao_or_xun_record=Quote.where(:cargo_id => params[:cargo_id])
    respond_to do |format|
      format.html # cargo.html.erb
      format.xml  { render :xml => @quotes }
    end
  end

  #one trucks's all baojia
  def truck
    @truck=Truck.find_by_id(params[:truck_id])
    @bao_or_xun_record=Quote.where(:truck_id => params[:truck_id], :user_id =>session[:user_id])
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
    @trucks = Truck.where(:user_id =>session[:user_id])
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
    @quote.cargo_user_id=@cargo.user_id
    @quote.cargo_company_id=@cargo.company_id
    @trucks = Truck.where(:user_id =>session[:user_id],:status=>"正在配货")
    @mytruck=Hash.new

    if params[:truck_id].nil?
      @trucks = Truck.where(:user_id =>session[:user_id],:status =>"正在配货")

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
    @trucks = Truck.where(:user_id =>session[:user_id])
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

  #  @quote.cargo_company_id=@cargo.company_id
  #  @quote.cargo_user_id=@cargo.user_id
    @quote.truck_company_id=@truck.company_id
    @quote.truck_user_id=@truck.user_id

    respond_to do |format|
      if @quote.save
        #update statistic
        Cargo.collection.update({'_id' => @quote.cargo_id},{'$inc' => {"total_baojia" => 1}})         
        #update  tstatistic
        Truck.collection.update({'_id' => @quote.truck_id},{'$inc' => {"total_baojia" => 1}})  
        flash[:notice]= "创建报价成功！"
        format.html { redirect_to(@quote, :notice => '创建报价成功.') }
        format.xml  { render :xml => @quote, :status => :created, :location => @quote }
      else
        @quote=nil
        flash[:notice]="创建报价失败,不能重复报价！" 
        format.html { render :template => "quotes/new" }
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
        format.html { redirect_to(@quote, :notice => '更新报价成功.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quote.errors, :status => :unprocessable_entity }
      end
    end
  end

  #only for owner of cargo
  def request_chenjiao
    @quote = Quote.find(params[:id])
    
   unless @quote.blank?
    #update truck status
    Truck.collection.update({'_id'=>@quote.truck_id},{'$set'=>{:status=>"邀请成交"}})
    Cargo.collection.update({'_id'=>@quote.cargo_id},{'$set'=>{:status=>"邀请成交"}})    
    Quote.collection.update({'_id'=>@quote.id},{'$set'=>{:status=>"邀请成交"}}) 
   else
    @quote=Inquery.find(params[:id])
     Truck.collection.update({'_id'=>@quote.truck_id},{'$set'=>{:status=>"邀请成交"}})
     Cargo.collection.update({'_id'=>@quote.cargo_id},{'$set'=>{:status=>"邀请成交"}})
     Inquery.collection.update({'_id'=>@quote.id},{'$set'=>{:status=>"邀请成交"}})
   end
   #expire line
    @cargo=Cargo.find_by_id(@quote.cargo_id)
    @truck=Truck.find_by_id(@quote.cargo_id)
    expire_line_cargo(@cargo.fcity_code,@cargo.tcity_code)
    expire_line_truck(@truck.fcity_code,@truck.tcity_code)
    
    #TOTO:notify all other related truck
    #All quotes to from this truck change to chenjiao
    @quotes=Quote.where(:truck_id =>@quote.truck_id , :status =>"正在配货")
    if  @quotes.size>0
      @quotes.each do |quote|
        Quote.collection.update({'truck_id'=>@quote.truck_id },{'$set'=>{:status=>"成交过期"}})
      end
    end
    #All Inquers from this cargo neec change to chenjiao
    @inqueries=Inquery.where(:cargo_id =>@quote.cargo_id,:status=>"正在配货")
    if  @inqueries.size>0
      @inqueries.each do |inquery|
        Inquery.collection.update({'cargo_id'=>@quote.cargo_id },{'$set'=>{:status=>"成交过期"}})
      end
    end

    respond_to do |format|
      format.html { redirect_to(:controller=>"cargos",:action=>"index" )}
    end
    
  end


  #only for owner of truck
  def confirm_chenjiao    
    @quote = Quote.find(params[:id])
    
    #update truck status
    Truck.collection.update({'_id'=>@quote.truck_id},{'$set'=>{:status=>"已成交"}})
    Cargo.collection.update({'_id'=>@quote.cargo_id},{'$set'=>{:status=>"已成交"}})
    Quote.collection.update({'_id'=>@quote.id},{'$set'=>{:status=>"已成交"}}) 

    respond_to do |format|
      format.html { redirect_to(:controller=>"trucks",:action=>"index" )}
    end    
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
