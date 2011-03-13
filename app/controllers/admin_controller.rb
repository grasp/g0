class AdminController < ApplicationController
  layout "admin"
    before_filter:admin_authorize,:except=>[:index] #for debug purpose
  def index
    
  end
  
  def tf56grasp
    @grasps=GraspRecord.where(:from_site=>"tf56").order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
        respond_to do |format|
      format.html{render :template=>"/admin/grasp"} # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end
  
  def quzhougrasp
    @grasps=GraspRecord.where(:from_site=>"quzhou").order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
        respond_to do |format|
      format.html{render :template=>"/admin/grasp"} # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end
  
  def gethourdata
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
    
    @all_hourdata=HourData.where.paginate(:page=>params[:page]||1,:per_page=>20)

  end
end
