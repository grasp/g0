#coding: utf-8
class ScansController < ApplicationController
  # GET /scans
  # GET /scans.xml
  include ScansHelper
  layout:nil
  def index
    @scans = Scan.all
    expired_truck=0
    expired_cargo=0
    #scan truck at first

    Truck.all.each do |truck|
      if compare_time_expired(truck.created_at,truck.send_date)==true

        #only for first time 过期
        if truck.status!="过期"
        #only can be once
        lstatistic=Lstatistic.find_by_line(truck.line)
        lstatistic.update_attribute(:valid_truck,lstatistic.valid_truck-1)
        truck.update_attribute(:status,"过期")
        #update the line statistic
        trucks=Truck.where("stock_truck_id = ? AND status = ?",truck.stock_truck_id,"配货")

        expired_truck+=1;
        if trucks.size==0
          StockTruck.find(truck.stock_truck_id).update_attribute(:status,"空闲")
        end
        end

      end
    end

    Cargo.all.each do |cargo|
      if compare_time_expired(cargo.created_at,cargo.send_date)==true

        if cargo.status!="过期"
        cargo.update_attribute(:status,"过期")
        cargos=Cargo.where("stock_cargo_id = ? AND status = ?",cargo.stock_cargo_id,"配车")
        
        #update the line statistic
        lstatistic=Lstatistic.find_by_line(cargo.line)
        lstatistic.update_attribute(:valid_cargo,lstatistic.valid_cargo-1)
        expired_cargo+=1
        
        if cargos.size==0
          StockCargo.find(cargo.stock_cargo_id).update_attribute(:status,"空闲")
        end
        end
      end
    end


    #update sans statistic
      
    scan=Hash.new
    scan[:total_stock_cargo]=StockCargo.count
    scan[:idle_stock_cargo]=StockCargo.where("status = ?","空闲").count
    scan[:total_stock_truck]=StockTruck.count
    scan[:idle_stock_truck]=StockTruck.where("status = ?","空闲").count
        
    scan[:total_cargo]=Cargo.count
    scan[:total_truck]=Truck.count

    scan [:expired_truck]=expired_truck
    scan[:expired_cargo]=expired_cargo

    scan[:chenjiao_cargo]=Cargo.where("status = ?","chenjiao").count
    scan[:chenjiao_truck]=Truck.where("status = ?","chenjiao").count
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
