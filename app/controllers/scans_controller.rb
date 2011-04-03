#coding: utf-8
class ScansController < ApplicationController
  # GET /scans
  # GET /scans.xml
  include ScansHelper
  include TrucksHelper
  include CargosHelper
  layout "admin"
  before_filter:admin_authorize,:except=>[:cargoexpire,:truckexpire,:expiretimer,:uinfoscan,:scan,:move]
  
  def scan 
   expired_truck=0
   expired_cargo=0
   start_time=Time.now
   truck_expire_line=Array.new
   cargo_expire_line=Array.new   
    truck_scan_start=Time.now
    #scan truck at first
    Truck.where(:status=>"正在配货").each do |truck|
     # Rails.logger.info "scan truck for expire!!"
     # puts "truck.created_at=#{truck.created_at || truck.updated_at},truck.send_date=#{truck.send_date}"
      if compare_time_expired(truck.updated_at,truck.send_date || "1")==true
        #only for first time 过期
        
        if truck.status =="正在配货"
        #first change truck status
       # Rails.logger.info "#{truck.paizhao},status=#{truck.status}"
        truck.update_attributes(:status=>"超时过期") #for debug purpose
        expired_truck+=1
        start=Time.now
        #update line statistic
        @lstatistic=Lstatistic.first(:conditions=>{:line=>truck.line})
        unless @lstatistic.nil?
        @lstatistic.inc(:valid_truck,-1)
        @lstatistic.inc(:expired_truck,1) 
        end
        
       # Lstatistic.collection.update({'line'=>truck.line},
       # {'$inc' => {"valid_truck" => -1,"expired_truck"=> 1}},{:upsert =>true})  
      
        #decrement valid truck for stock truck
        @stock_truck= StockTruck.find(truck.stock_truck_id)  unless( truck.nil?  || truck.stock_truck_id.nil?) 
        @stock_truck.inc(:valid_truck,-1) unless @stock_truck.nil?
        
         # StockTruck.collection.update({:_id=>truck.stock_truck_id},{'$inc' => {"valid_truck" => -1}}) 
        if truck.from_site=="local"          
           @user=User.find(truck.user_id) unless truck.nil?
           @user.inc(:valid_truck,-1) unless @user.nil?
          # User.collection.update({:_id=>truck.user_id},{'$inc' =>{:valid_truck=>-1}})         
        end
        
        #change all inquery and quote status 
        
   #Debug Scan
       Inquery.where(:conditions=>{:truck_id=>truck.id}).each {|inquery| inquery.update_attributes(:status=>"超时过期")}
       Quote.where(:conditions=>{:truck_id=>truck.id}).each {|quote| quote.update_attributes(:status=>"超时过期")}
       
       # Inquery.collection.update({:truck_id=>truck.id},{'$set' =>{:status=>"超时过期"}})
       # Quote.collection.update({:truck_id=>truck.id},{'$set' =>{:status=>"超时过期"}})  
        
        end_time=Time.now
       # Rails.logger.info "update time=#{end_time-start}sec"
        #expire line
        start=Time.now
        begin
          iterate_expire_line(truck_expire_line,truck.fcity_code,truck.tcity_code)          
        rescue
       #   raise
         # Rails.logger.info "exception #{$@}for expire line truck#{truck.fcity_code} to #{truck.tcity_code}"
        end
        end_time=Time.now
        #Rails.logger.info "quick truck exprie time=#{end_time-start}sec"
        expire_page(:controller=>"trucks",:action=>"show",:id=>truck.id)
        end
      end

    end
     truck_expire_line.each do |line|
          FileUtils.rm_rf Rails.public_path+"/trucks/search"+"/#{line[0]}"+"/#{line[1]}"       
        #  Rails.logger.debug "expire "+Rails.public_path+"/trucks/search"+"/#{line[0]}"+"/#{line[1]}"
       end
     end_time=Time.now
    # Rails.logger.info "total truck exprie time=#{end_time-truck_scan_start}sec"
     
    #initialize the status if no any truck issued
    StockTruck.where.each do |stock_truck|
      if stock_truck.valid_truck.blank? || stock_truck.valid_truck==0 
        # StockTruck.collection.update({:_id=>stock_truck.id},{'$set' => {"status" => "车辆闲置"}})
         stock_truck.update_attributes("status" => "车辆闲置")
      end
    end
    cargo_scan_start=Time.now
    Cargo.where(:status=>"正在配车").each do |cargo|
    #   puts "cargo.created_at=#{cargo.created_at},cargo.send_date=#{cargo.send_date}"
      if compare_time_expired(cargo.updated_at,cargo.send_date || "1")==true
        if cargo.status=="正在配车"
          # first update cargo status
         cargo.update_attributes(:status=>"超时过期")
           expired_cargo+=1
           lstatistic=Lstatistic.first(:conditions=>{:line=>cargo.line})
           unless  lstatistic.nil?
            lstatistic.inc(:valid_cargo,-1)
            lstatistic.inc(:expired_cargo,1) 
           end
         #update line statistic
         #Lstatistic.collection.update({'line'=>cargo.line},
         #{'$inc' => {"valid_cargo" => -1,"expired_cargo"=> 1}},{:upsert =>true})

          #decrement valid cargo for stock cargo
          begin
          stockcargo=StockCargo.find(cargo.stock_cargo_id) unless( cargo.nil?  || cargo.stock_cargo_id.nil?) 
          rescue
            Rails.logger.info "miss stock_cargo_id for expired cargo"
            next
          end
          stockcargo.inc(:valid_cargo,-1) unless stockcargo.nil?
        #  StockCargo.collection.update({:_id=>cargo.stock_cargo_id},{'$inc' => {"valid_cargo" => -1}})
          
        if cargo.from_site=="local"
          @user=User.find(cargo.user_id)
          @user.inc(:valid_cargo,-1) unless @user.nil?
         # User.collection.update({:_id=>cargo.user_id},{'$inc' =>{:valid_cargo=>-1}}) 
        end
          
        #change all inquery and quote status 
        Inquery.where(:conditions=>{:cargo_id=>cargo.id}).each {|inquery| inquery.update_attributes(:status=>"超时过期")}
        Quote.where(:conditions=>{:cargo_id=>cargo.id}).each {|quote| quote.update_attributes(:status=>"超时过期")}

       # Inquery.collection.update({:truck_id=>cargo.id},{'$set' =>{:status=>"超时过期"}})
       # Quote.collection.update({:truck_id=>cargo.id},{'$set' =>{:status=>"超时过期"}})
        begin
        iterate_expire_line(cargo_expire_line,cargo.fcity_code,cargo.tcity_code)
        rescue
           Rails.logger.info "exception for expire line cargo #{cargo.fcity_code} to #{cargo.tcity_code}"
        end
        expire_page(:controller=>"cargos",:action=>"show",:id=>cargo.id)
        end
      end
    end
    
     cargo_expire_line.each do |line|
          FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"       
         # Rails.logger.debug "expire "+Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"
       end
     end_time=Time.now
    # Rails.logger.info "total cargo exprie time=#{end_time-cargo_scan_start}sec"
    
  #initialize all stockcargo
   StockCargo.where.each do |stock_cargo|
      if stock_cargo.valid_cargo .blank?||stock_cargo.valid_cargo==0
        # StockCargo.collection.update({:_id=>stock_cargo.id},{'$set' => {"status" => "货物闲置"}})
      #  stock_cargo.update_attributes("status" => "货物闲置")
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
  
  def scaninfo
     @scans = Scan.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
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
   # Rails.logger.debug "expiredtruck.count=#{ExpiredTruck.count}"
    Cargo.where(:status=>"超时过期").each do |cargo|
      expiredcargo=ExpiredCargo.new(:id=>cargo.id)
      cargo.keys.each do |key| 
        expiredcargo[key[0]]=cargo[key[0]]
      end
      expiredcargo.save
      cargo.destroy
      @move.expired_cargo+=1
    end
   # Rails.logger.debug "expiredcargo.count=#{ExpiredCargo.count}"
    
    Quote.where(:status=>"超时过期").each do |quote|
      expiredquote=ExpiredQuote.new
      quote.keys.each do |key| 
      expiredquote[key[0]]=quote[key[0]]
      end
      expiredquote.save
      quote.destroy
      @move.expired_quote+=1
   end
  # Rails.logger.debug "expiredquote.count=#{ExpiredQuote.count}"
   Inquery.where(:status=>"超时过期").each do |inquery|
      expiredinquery=ExpiredInquery.new
      inquery.keys.each do |key| 
        expiredinquery[key[0]]=inquery[key[0]]
      end
      expiredinquery.save
      inquery.destroy
      @move.expired_inquery+=1
   end
  # Rails.logger.debug "expiredinquery.count=#{ExpiredInquery.count}"
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
  # puts @grasps
   @grasps.each do |grasp|
     @cargolines+=grasp.cargo_lines unless grasp.cargo_lines.nil? 
    # GraspRecord.collection.update({"_id"=>grasp.id},{'$set'=>{:cargostatus=>"expired"}}) 
     grasp.update_attributes(:cargostatus=>"expired")
    # Rails.logger.debug grasp.cargo_lines    
   end

   @cargolines=@cargolines.uniq   
   unless @cargolines.size==0
      @cargolines.each do |line|
       FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"       
      # Rails.logger.debug "expire "+Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"
    end
   end
    respond_to do |format|
      format.html{ render :template=>"/scans/cargoexpire"} # index.html.erb
    end
   end

  #only for grasp line, no 
  def truckexpire
   @trucklines=Array.new
   @grasps=GraspRecord.where({:truckstatus=>"notexpired"})
   Rails.logger.debug "truck grasps size=="+@grasps.size.to_s

   @grasps.each do |grasp|
     @trucklines+=grasp.truck_lines unless grasp.truck_lines.nil? 
    # GraspRecord.collection.update({"_id"=>grasp.id},{'$set'=>{:truckstatus=>"expired"}})        
     grasp.update_attributes(:truckstatus=>"expired")
   end

   @trucklines=@trucklines.uniq   
   unless @trucklines.size==0
      @trucklines.each do |line|
       FileUtils.rm_rf Rails.public_path+"/trucks/search"+"/#{line[0]}"+"/#{line[1]}"       
       Rails.logger.debug "expire "+Rails.public_path+"/trucks/search"+"/#{line[0]}"+"/#{line[1]}"
    end
   end
    respond_to do |format|
      format.html{ render :template=>"/scans/truckexpire"} # index.html.erb
    end
  end
  
  def expiretimer
     FileUtils.rm_rf Rails.public_path+"/trucks/search"+"/100000000000"+"/100000000000"                                                                           
     FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/100000000000"+"/100000000000"  
     FileUtils.rm_rf Rails.public_path+"/index.html"  
     FileUtils.rm_rf Rails.public_path+"/cargos"+"/search.html"
     FileUtils.rm_rf Rails.public_path+"/trucks"+"/search.html"
     Rails.logger.debug "expire anywhere to anywhere for cargo and truck "
     
    respond_to do |format|
      format.html{ render :template=>"/scans/expiretimer"} # index.html.erb
    end
  end
  
  def uinfoscan
     Ustatistic.all.each do |ustatistic|
       valid_cargo=Cargo.where(:status=>"正在配车",:user_id=>ustatistic.user_id).count
       if ustatistic.valid_cargo !=valid_cargo
       # Ustatistic.collection.update({:user_id=>ustatistic.user_id},{'$set'=>{:valid_cargo=>valid_cargo}})
        ustatistic.update_attributes(:valid_cargo=>valid_cargo)
        Rails.logger.debug "found not correct valid_cargo for user "
       end
       valid_truck=Truck.where(:status=>"正在配货",:user_id=>ustatistic.user_id).count
       if ustatistic.valid_truck !=valid_truck
       Ustatistic.collection.update({:user_id=>ustatistic.user_id},{'$set'=>{:valid_truck=>valid_truck}})
        ustatistic.update_attributes(:valid_truck=>valid_truck)
       end
     end
    
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
