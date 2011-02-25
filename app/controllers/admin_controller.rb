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
end
