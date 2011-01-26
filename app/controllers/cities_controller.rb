 #coding: utf-8
class CitiesController < ApplicationController
  # GET /cities
  # GET /cities.xml
  layout :nil

  def index
    #get the original value
    if params[:dir]=="from"
    code=params[:code] ||( params[:search][:fcity_code] unless params[:search].nil?)
    elsif  params[:dir]=="to"
    code=params[:code] || (params[:search][:tcity_code] unless params[:search].nil?)
    end
       
    
     if code.nil? || code=="100000000000"
      code="330100000000" #default open ZheJiang Province
      puts "code is nil !!!"
    end    
    
    @selected_city_code=code    
    puts "we received city code request=#{code}"    
    if code.match(/\d\d0000000000$/) # is a province id  
      @selected_city_name= $province_region[code]
       @province_code=code
       @region=$citytree[@province_code]
      
    elsif code.match(/\d\d\d\d00000000$/)  and (not code.match(/\d\d0000000000$/))
       @selected_city_name= $province_region[code.slice(0,2)+"0000000000"]+$province_region[code]
       @province_code=code.slice(0,2)+"0000000000"
       @region_code=code  
       @region=$citytree[@province_code]
    else
      @province_code=code.slice(0,2)+"0000000000"
      @region_code=code.slice(0,4)+"00000000"
      @city_code=code
      @region=$citytree[@province_code]
      @selected_city_name= $province_region[@province_code]+$province_region[@region_code]+$citytree[@province_code][@region_code][code]
    end    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cities }
    end
  end

  # GET /cities/1
  # GET /cities/1.xml
  def show
    @city = City.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/new
  # GET /cities/new.xml
  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/1/edit
  def edit
    @city = City.find(params[:id])
  end

  # POST /cities
  # POST /cities.xml
  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        format.html { redirect_to(@city, :notice => 'City was successfully created.') }
        format.xml  { render :xml => @city, :status => :created, :location => @city }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.xml
  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to(@city, :notice => 'City was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.xml
  def destroy
    @city = City.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to(cities_url) }
      format.xml  { head :ok }
    end
  end
end
