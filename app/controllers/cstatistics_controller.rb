class CstatisticsController < ApplicationController
  # GET /cstatistics
  # GET /cstatistics.xml
  def index
    @cstatistics = Cstatistic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cstatistics }
    end
  end

  # GET /cstatistics/1
  # GET /cstatistics/1.xml
  def show
    @cstatistic = Cstatistic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cstatistic }
    end
  end

  # GET /cstatistics/new
  # GET /cstatistics/new.xml
  def new
    @cstatistic = Cstatistic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cstatistic }
    end
  end

  # GET /cstatistics/1/edit
  def edit
    @cstatistic = Cstatistic.find(params[:id])
  end

  # POST /cstatistics
  # POST /cstatistics.xml
  def create
    @cstatistic = Cstatistic.new(params[:cstatistic])

    respond_to do |format|
      if @cstatistic.save
        format.html { redirect_to(@cstatistic, :notice => 'Cstatistic was successfully created.') }
        format.xml  { render :xml => @cstatistic, :status => :created, :location => @cstatistic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cstatistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cstatistics/1
  # PUT /cstatistics/1.xml
  def update
    @cstatistic = Cstatistic.find(params[:id])

    respond_to do |format|
      if @cstatistic.update_attributes(params[:cstatistic])
        format.html { redirect_to(@cstatistic, :notice => 'Cstatistic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cstatistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cstatistics/1
  # DELETE /cstatistics/1.xml
  def destroy
    @cstatistic = Cstatistic.find(params[:id])
    @cstatistic.destroy

    respond_to do |format|
      format.html { redirect_to(cstatistics_url) }
      format.xml  { head :ok }
    end
  end
end
