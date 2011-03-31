# coding: utf-8
class AdminController < ApplicationController
  layout "admin"
 #   before_filter:admin_authorize,:except=>[:index] #for debug purpose
  before_filter:admin_authorize, :except=>[:gethourdata,:move] #for debug purpose
  def index
    
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
       if HourData.where(:datehour=>Time.now.to_s.slice(0,13)).first.blank?
      @lastdata=HourData.last
      @hourdata=HourData.new
      @hourdata.total_user=User.count
      @hourdata.total_contact=UserContact.count
      @hourdata.total_company=Company.count
      @hourdata.total_cargo=Cargo.count
      @hourdata.total_truck=Cargo.count
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
  end
  
  def hourscaninfo

    
    @all_hourdata=HourData.where.paginate(:page=>params[:page]||1,:per_page=>20)

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
    
    
    
     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @moves }
    end

    
  end
  
   def moveinfo
     @moves=Move.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end
   
   
end
