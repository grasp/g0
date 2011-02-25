# coding: utf-8
class PublicController < ApplicationController
before_filter:authorize_public
layout "public",:except=>:navibar
#caches_page:about
 
  def index

    @search=Search.new
    @search.fcity_name="选择出发地"
    @search.tcity_name="选择到达地"
    @search.fcity_code="100000000000"
    @search.tcity_code="100000000000"
    @search.save
       

   # puts "params[:page]=#{params[:page]}"
    respond_to do |format|
       if params[:page]
         #puts "render without layout"
         format.html {render :layout=>nil}# index.html.erb
       else
        # puts "render with layout"
          format.html {}# new.html.erb
       end
         
      format.xml  {render :xml => @search }
    end
  end

  def navibar
     respond_to do |format|
      format.html {}# navi.html.erb
    #  format.xml  {render :xml => @search }
    end
  end
  
  def about
     respond_to do |format|
      format.html {render :template=>"/public/about"}# navi.html.erb
    #  format.xml  {render :xml => @search }
    end
  end
  
  def mianze
         respond_to do |format|
      format.html {render :template=>"/public/mianze"}# navi.html.erb
    #  format.xml  {render :xml => @search }
    end
  end

end
