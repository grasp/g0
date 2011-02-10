#coding: utf-8
class ScansController < ApplicationController
  # GET /scans
  # GET /scans.xml
  include ScansHelper
  layout:nil
  def index
    @scans = Scan.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)

   expired_truck=0
   expired_cargo=0
    #scan truck at first
    Truck.all.each do |truck|
      puts "truck.created_at=#{truck.created_at || truck.updated_at},truck.send_date=#{truck.send_date}"
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
         end
      end
    end

    StockTruck.all.each do |stock_truck|
      if stock_truck.count==0
         StockTruck.collection.update({:_id=>stock_truck_id},{'$set' => {"status" => "车辆闲置"}})
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
        end
      end
    end

   StockCargo.all.each do |stock_cargo|
      if stock_cargo.count==0
         StockCargo.collection.update({:_id=>stock_cargo_id},{'$set' => {"status" => "货物闲置"}})
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

    scan[:expired_truck]=expired_truck
    scan[:expired_cargo]=expired_cargo

    scan[:chenjiao_cargo]=Cargo.where(:status =>"已成交").count
    scan[:chenjiao_truck]=Truck.where(:status =>"已成交").count
    scan[:total_line]=Lstatistic.count
    scan[:total_user]=User.count
    scan[:total_company]=Company.count
    scan[:user_id]=session[:user_id]
    
    @scan = Scan.new(scan)
    @scan.save
    # we will do scan work in this action

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
