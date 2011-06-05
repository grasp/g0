# coding: utf-8
class AdminController < ApplicationController
  layout "admin"
  include Tf56graspHelper
  include QuzhougraspHelper
  include ScansHelper
  include AdminHelper
 #   before_filter:admin_authorize,:except=>[:index] #for debug purpose
  before_filter:admin_authorize, :except=>[:grasp_tf56,:grasp_quzhou,:scan,:move] #for debug purpose
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

  def scan
    scan_helper
  end
    def scan_info
   @scans=Scan.all.desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
  end
  def move
move_helper
    
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

   def get_room_contact
a=[Cargo,Truck,ExpiredCargo,ExpiredTruck]
a.each do |records|
  records.where("from_site"=>"tf56").each do |record|
    unless record.comments.blank?
    room=record.comments.to_s.split(/\s/)[0].strip.slice(0,6)
    contact=record.comments.gsub(room,"").strip
    check=RoomContact.where("room"=>room).first
    RoomContact.create("room"=>room,"contact"=>contact,"from"=>room.gsub(/\w||\d/,"").split[0].strip) if  (!room.blank? && contact.size>4 && check.blank?)
   end
  end
end

     @rooms=RoomContact.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   end

      def show_room_contact
         @rooms=RoomContact.all.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
        respond_to do |format|
      format.html { render :action => '/admin/get_room_contact' }
      end
      end
      def grasp_tf56
      get_tf56_grasps
      end

      def grasp_quzhou
       get_quzhou_grasps
      end
   def show_cron_mail
     @log=`cat /var/mail/hunter`
     @logs=@log.split("\n")
   end
def daily_trends
  show_daily_trends
end

def hourly_trends
  show_hourly_trends
end

def request_log_analysis

helper_request_log_analysis
end

def show_log
  show_log_helper
end
end
