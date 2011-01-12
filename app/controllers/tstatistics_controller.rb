class TstatisticsController < ApplicationController
  # GET /tstatistics
  # GET /tstatistics.xml
  def index
    @tstatistics = Tstatistic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tstatistics }
    end
  end

  # GET /tstatistics/1
  # GET /tstatistics/1.xml
  def show
    @tstatistic = Tstatistic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tstatistic }
    end
  end

  # GET /tstatistics/new
  # GET /tstatistics/new.xml
  def new
    @tstatistic = Tstatistic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tstatistic }
    end
  end

  # GET /tstatistics/1/edit
  def edit
    @tstatistic = Tstatistic.find(params[:id])
  end

  # POST /tstatistics
  # POST /tstatistics.xml
  def create
    @tstatistic = Tstatistic.new(params[:tstatistic])

    respond_to do |format|
      if @tstatistic.save
        format.html { redirect_to(@tstatistic, :notice => 'Tstatistic was successfully created.') }
        format.xml  { render :xml => @tstatistic, :status => :created, :location => @tstatistic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tstatistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tstatistics/1
  # PUT /tstatistics/1.xml
  def update
    @tstatistic = Tstatistic.find(params[:id])

    respond_to do |format|
      if @tstatistic.update_attributes(params[:tstatistic])
        format.html { redirect_to(@tstatistic, :notice => 'Tstatistic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tstatistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tstatistics/1
  # DELETE /tstatistics/1.xml
  def destroy
    @tstatistic = Tstatistic.find(params[:id])
    @tstatistic.destroy

    respond_to do |format|
      format.html { redirect_to(tstatistics_url) }
      format.xml  { head :ok }
    end
  end
end
