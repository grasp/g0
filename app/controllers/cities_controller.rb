 # coding: utf-8
class CitiesController < ApplicationController
  # GET /cities
  # GET /cities.xml
  layout :nil

  def index

    @selected_city_code=code=params[:code]  

  
    if code.nil?
      @selected_city_name=nil
      @selected_city_code=nil
    else
    @selected_city_name=City.get_full_name_by_code(code)
     @selected_city_code=code
    end

    @selected_city_code ||="330106000000"

    if code.nil? || code=="100000000000"
      code="330106000000"
      puts "code is nil !!!"
    end
    @province=City.find_by_code(code[0..1]+"0000000000")
    logger.debug("we got a code=#{code}")

    puts "index get code =#{code},selected_code=#{@selected_city_code}"

    ret=City.get_region_city_by_code(code)
    
    @region_list=ret[0]
    @city_list=ret[1]


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
