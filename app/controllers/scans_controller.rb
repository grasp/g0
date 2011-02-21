#coding: utf-8
class ScansController < ApplicationController
  # GET /scans
  # GET /scans.xml
  include ScansHelper
  include TrucksHelper
  include CargosHelper
  layout:nil
  before_filter:admin_authorize, :only => [:index]
  
  def scan 
   expired_truck=0
   expired_cargo=0
   start_time=Time.now
    #scan truck at first
    Truck.all.each do |truck|
     # puts "truck.created_at=#{truck.created_at || truck.updated_at},truck.send_date=#{truck.send_date}"
      if compare_time_expired(truck.created_at ||truck.updated_at,truck.send_date || "1")==true
        #only for first time 过期
        if truck.status=="正在配货"
        #first change truck status
        truck.update_attributes(:status=>"超时过期")
        expired_truck+=1
        #update line statistic
        Lstatistic.collection.update({'line'=>truck.line},
        {'$inc' => {"valid_truck" => -1,"expired_truck"=> 1}},{:upsert =>true})       
        #decrement valid truck for stock truck
        StockTruck.collection.update({:truck_id=>truck.id},{'$inc' => {"valid_truck" => -1}})        
        #change all inquery and quote status 
        Inquery.collection.update({:truck_id=>truck.id},{'$set' =>{:status=>"超时过期"}})
        Quote.collection.update({:truck_id=>truck.id},{'$set' =>{:status=>"超时过期"}})      
        #expire line
        expire_line_truck(truck.fcity_code,truck.tcity_code)
         expire_page(:controller=>"trucks",:action=>"show",:id=>truck.id)
        end
      end
    end

    #initialize the status if no any truck issued
    StockTruck.all.each do |stock_truck|
      if stock_truck.valid_truck==0
         StockTruck.collection.update({:_id=>stock_truck.id},{'$set' => {"status" => "车辆闲置"}})
      end
    end
    
    Cargo.all.each do |cargo|
    #   puts "cargo.created_at=#{cargo.created_at},cargo.send_date=#{cargo.send_date}"
      if compare_time_expired(cargo.created_at ||cargo.updated_at,cargo.send_date || "1")==true
        if cargo.status=="正在配车"
          # first update cargo status
          cargo.update_attributes(:status=>"超时过期")
          expired_cargo+=1
         #update line statistic
         Lstatistic.collection.update({'line'=>cargo.line},
         {'$inc' => {"valid_cargo" => -1,"expired_cargo"=> 1}},{:upsert =>true})

          #decrement valid cargo for stock cargo
          StockCargo.collection.update({:cargo_id=>cargo.id},{'$inc' => {"valid_cargo" => -1}})
          
        #change all inquery and quote status 
        Inquery.collection.update({:truck_id=>cargo.id},{'$set' =>{:status=>"超时过期"}})
        Quote.collection.update({:truck_id=>cargo.id},{'$set' =>{:status=>"超时过期"}})
        expire_line_cargo(cargo.fcity_code,cargo.tcity_code)
        expire_page(:controller=>"cargos",:action=>"show",:id=>cargo.id)
        end
      end
    end
    
  #initialize all stockcargo
   StockCargo.all.each do |stock_cargo|
      if stock_cargo.valid_cargo==0
         StockCargo.collection.update({:_id=>stock_cargo.id},{'$set' => {"status" => "货物闲置"}})
      end
    end


    #update sans statistic      
    scan=Hash.new
    scan[:total_stock_cargo]=StockCargo.count
    scan[:idle_stock_cargo]=StockCargo.where(:status =>"货物闲置").count
    scan[:total_stock_truck]=StockTruck.count
    scan[:idle_stock_truck]=StockTruck.where(:status =>"车辆闲置").count
        
    scan[:total_cargo]=Cargo.count
    scan[:total_truck]=Truck.count
    
    scan[:valid_truck]=Truck.where(:status=>"正在配货").count
    scan[:valid_cargo]=Cargo.where(:status=>"正在配车").count


    scan[:expired_truck]=expired_truck
    scan[:expired_cargo]=expired_cargo

    scan[:chenjiao_cargo]=Cargo.where(:status =>"已成交").count
    scan[:chenjiao_truck]=Truck.where(:status =>"已成交").count
    scan[:total_line]=Lstatistic.count
    scan[:total_user]=User.count
    scan[:total_company]=Company.count
    scan[:user_id]=session[:user_id]
    #calculate time cost
     end_time=Time.now
    scan[:cost_time]=end_time-start_time
    @scan = Scan.new(scan)
    @scan.save
    # we will do scan work in this action

   @scans = Scan.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    respond_to do |format|
      format.html{ render :template=>"/scans/index"} # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end
  
  #move out expired cargo/truck/inquery/quote, this can keep simple  and fast for main function  
  def move
    @move=Move.new
      @move.expired_cargo=0
      @move.expired_truck=0
      @move.expired_quote=0
      @move.expired_inquery=0
    start_time=Time.now
    Truck.where(:status=>"超时过期").each do |truck|
      expiredtruck=ExpiredTruck.new
      truck.keys.each do |key| 
      expiredtruck[key[0]]=truck[key[0]]
      end
      expiredtruck.save      
      truck.destroy
      @move.expired_truck+=1
    end
    Rails.logger.debug "expiredtruck.count=#{ExpiredTruck.count}"
    Cargo.where(:status=>"超时过期").each do |cargo|
      expiredcargo=ExpiredCargo.new(:id=>cargo.id)
      cargo.keys.each do |key| 
      expiredcargo[key[0]]=cargo[key[0]]
      end
      expiredcargo.save
      cargo.destroy
      @move.expired_cargo+=1
    end
    Rails.logger.debug "expiredcargo.count=#{ExpiredCargo.count}"
    
    Quote.where(:status=>"超时过期").each do |quote|
      expiredquote=ExpiredQuote.new
      quote.keys.each do |key| 
      expiredquote[key[0]]=quote[key[0]]
      end
      expiredquote.save
      quote.destroy
      @move.expired_quote+=1
   end
   Rails.logger.debug "expiredquote.count=#{ExpiredQuote.count}"
   Inquery.where(:status=>"超时过期").each do |inquery|
      expiredinquery=ExpiredInquery.new
      inquery.keys.each do |key| 
        expiredinquery[key[0]]=inquery[key[0]]
      end
      expiredinquery.save
      inquery.destroy
      @move.expired_inquery+=1
   end
   Rails.logger.debug "expiredinquery.count=#{ExpiredInquery.count}"
    end_time=Time.now
    @move.cost_time=end_time-start_time
    
    @move.save
    
    @moves=Move.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    
     respond_to do |format|
      format.html{ render :template=>"/admin/move"} # index.html.erb
      format.xml  { render :xml => @moves }
    end

    
  end
  #for grasp line
  def cargoexpire
   @cargolines=Array.new
   @grasps=GraspRecord.where({:cargostatus=>"notexpired"})
   Rails.logger.debug "grasps size=="+@grasps.size.to_s
   puts @grasps
   @grasps.each do |grasp|
     @cargolines+=grasp.cargo_lines unless grasp.cargo_lines.nil? 
     GraspRecord.collection.update({"_id"=>grasp.id},{'$set'=>{:cargostatus=>"expired"}}) 
     Rails.logger.debug grasp.cargo_lines    
   end

   @cargolines=@cargolines.uniq   
   unless @cargolines.size==0
      @cargolines.each do |line|
       FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"       
       Rails.logger.debug "expire "+Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"
    end
   end
   end

  #for grasp line
  def truckexpire
   @trucklines=Array.new
   @grasps=GraspRecord.where({:truckstatus=>"notexpired"})
   Rails.logger.debug "truck grasps size=="+@grasps.size.to_s

   @grasps.each do |grasp|
     @trucklines+=grasp.truck_lines unless grasp.truck_lines.nil? 
     GraspRecord.collection.update({"_id"=>grasp.id},{'$set'=>{:truckstatus=>"expired"}})        
   end

   @trucklines=@trucklines.uniq   
   unless @trucklines.size==0
      @trucklines.each do |line|
       FileUtils.rm_rf Rails.public_path+"/trucks/search"+"/#{line[0]}"+"/#{line[1]}"       
       Rails.logger.debug "expire "+Rails.public_path+"/trucks/search"+"/#{line[0]}"+"/#{line[1]}"
    end
   end
  end
  
  def expiretimer
     FileUtils.rm_rf Rails.public_path+"/trucks/search"+"/100000000000"+"/100000000000"  
     FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/100000000000"+"/100000000000"       
     Rails.logger.debug "expire anywhere to anywhere for cargo and truck "
  end
  
  def index
    @scans = Scan.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end

  # GET /scans/1
  # GET /scans/1.xml
  def show
    @scan = Scan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scan }
    end
  end

  # GET /scans/new
  # GET /scans/new.xml
  def new
    @scan = Scan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scan }
    end
  end

  # GET /scans/1/edit
  def edit
    @scan = Scan.find(params[:id])
  end

  # POST /scans
  # POST /scans.xml
  def create
    @scan = Scan.new(params[:scan])
    respond_to do |format|
      if @scan.save
        format.html { redirect_to(@scan, :notice => 'Scan was successfully created.') }
        format.xml  { render :xml => @scan, :status => :created, :location => @scan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /scans/1
  # PUT /scans/1.xml
  def update
    @scan = Scan.find(params[:id])

    respond_to do |format|
      if @scan.update_attributes(params[:scan])
        format.html { redirect_to(@scan, :notice => 'Scan was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /scans/1
  # DELETE /scans/1.xml
  def destroy
    @scan = Scan.find(params[:id])
    @scan.destroy

    respond_to do |format|
      format.html { redirect_to(scans_url) }
      format.xml  { head :ok }
    end
  end
end
