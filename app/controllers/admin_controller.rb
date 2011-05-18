# coding: utf-8
class AdminController < ApplicationController
  layout "admin"
 #   before_filter:admin_authorize,:except=>[:index] #for debug purpose
  before_filter:admin_authorize, :except=>[:hourscan,:move] #for debug purpose
  def index
    @today=Hash.new
    @today["huo"]=Cargo.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count
    @today["che"]=Truck.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count
    @today["quote"]=Quote.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count
    @today["inquery"]=Inquery.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count
    @today["user"]=User.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count
    @today["company"]=Company.where(:created_at.lte=>Time.now,:created_at.gte=>Time.now-86400).count

    @yesterday=Hash.new
     @yesterday["huo"]=Cargo.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
     @yesterday["che"]=Truck.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
     @yesterday["quote"]=Quote.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
     @yesterday["inquery"]=Inquery.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
     @yesterday["user"]=User.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
     @yesterday["company"]=Company.where(:created_at.lte=>Time.now-86400,:created_at.gte=>Time.now-172800).count
  end
  
  def tf56grasp
    @grasps=GraspRecord.where(:from_site=>"tf56").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
        respond_to do |format|
      format.html{render :template=>"/admin/grasp"} # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end
  
  def quzhougrasp
    @grasps=GraspRecord.where(:from_site=>"quzhou").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
        respond_to do |format|
      format.html{render :template=>"/admin/grasp"} # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end
  
  def hourscan
   
      @lastdata=HourData.last
      @hourdata=HourData.new
      @hourdata.total_user=User.count
      @hourdata.total_contact=UserContact.count
      @hourdata.total_company=Company.count
      @hourdata.total_cargo=Cargo.count
      @hourdata.total_truck=Truck.count
      @hourdata.total_quote=Quote.count
      @hourdata.total_inquery=Inquery.count
      unless @lastdata.blank?  
      @hourdata.user_new=@hourdata.total_user-@lastdata.total_user 
      @hourdata.contact_new=@hourdata.total_contact-@lastdata.total_contact
      @hourdata.company_new=@hourdata.total_company-@lastdata.total_company
      @hourdata.cargo_new=@hourdata.total_cargo-@lastdata.total_cargo
      @hourdata.truck_new=@hourdata.total_truck-@lastdata.total_truck
      @hourdata.quote_new=@hourdata.total_quote-@lastdata.total_quote
      @hourdata.inquery_new=@hourdata.total_inquery-@lastdata.total_inquery      
      @hourdata.save
      else          
      @hourdata.user_new=0
      @hourdata.contact_new=0
      @hourdata.company_new=0
      @hourdata.cargo_new=0
      @hourdata.truck_new=0
      @hourdata.quote_new=0
      @hourdata.inquery_new=0
      @hourdata.save
      end
 
  end
  
  def hourscaninfo

    
    @all_hourdata=HourData.all.desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)

  end
  
  def move
    @move=Move.new
      @move.expired_cargo=0
      @move.expired_truck=0
      @move.expired_quote=0
      @move.expired_inquery=0
    start_time=Time.now
    Truck.where(:status=>"超时过期").each do |truck|
      expiredtruck=ExpiredTruck.new
      truck.raw_attributes.keys.each do |key| 
      expiredtruck[key[0]]=truck[key[0]]
      end
      expiredtruck.save      
      truck.destroy
      @move.expired_truck+=1
    end
    Rails.logger.debug "expiredtruck.count=#{ExpiredTruck.count}"
    Cargo.where(:status=>"超时过期").each do |cargo|
      expiredcargo=ExpiredCargo.new(:id=>cargo.id)
      cargo.raw_attributes.keys.each do |key| 
        expiredcargo[key[0]]=cargo[key[0]]
      end
      expiredcargo.save
      cargo.destroy
      @move.expired_cargo+=1
    end
    Rails.logger.debug "expiredcargo.count=#{ExpiredCargo.count}"
    
    Quote.where(:status=>"超时过期").each do |quote|
      expiredquote=ExpiredQuote.new
      quote.raw_attributes.keys.each do |key| 
      expiredquote[key[0]]=quote[key[0]]
      end
      expiredquote.save
      quote.destroy
      @move.expired_quote+=1
   end
   Rails.logger.debug "expiredquote.count=#{ExpiredQuote.count}"
   Inquery.where(:status=>"超时过期").each do |inquery|
      expiredinquery=ExpiredInquery.new
      inquery.raw_attributes.keys.each do |key| 
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
    
    
    
     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @moves }
    end

    
  end
  
   def moveinfo
     @moves=Move.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end

   def cargo_manage
     @cargos = Cargo.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end

  def stockcargo_manage
    @stock_cargos = StockCargo.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
  end

   def truck_manage
     @trucks = Truck.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end

   def stocktruck_manage
      @stock_trucks = StockTruck.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end

   def inquery_manage
      @inqueries = Inquery.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end
   def quote_manage
     @quotes = Quote.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end

   def usercontact_manage
       @user_contacts = UserContact.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end

   def user_manage
      @users = User.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end

   def company_manage
       @companies = Company.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end

   
end
