class AdminController < ApplicationController
  layout "admin",:only=>[:index]
  def index
    
  end
  
  def tf56grasp
    @grasps=Tf56grasp.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
        respond_to do |format|
      format.html{render :template=>"/admin/grasp"} # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end
  
  def quzhougrasp
    @grasps=Quzhougrasp.where.order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
        respond_to do |format|
      format.html{render :template=>"/admin/grasp"} # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end
end
