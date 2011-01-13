# coding: utf-8
class StockCargosController < ApplicationController
  # GET /stock_cargos
  # GET /stock_cargos.xml
  include StockCargosHelper
  before_filter:authorize
  protect_from_forgery :except => [:tip,:login]
  # layout "public"
  layout :nil

  def index
    #for admin purpose
    #@stock_cargos = StockCargo.all
    #
    #this if for logined user only
   # @stock_cargos = StockCargo.where("user_id = ?",session[:user_id]).order("created_at desc").paginate(:page=>params[:page]||1,:per_page=>5)
  # @stock_cargos = StockCargo.all(:user_id =>session[:user_id]).sort(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>5)
    @stock_cargos = StockCargo.where(:user_id =>session[:user_id]).paginate(:page=>params[:page]||1,:per_page=>5)
    @stock_cargos .each do |p|
      puts "stock_cargo=#{p}"
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_cargos }
    end
  end

  # GET /stock_cargos/1
  # GET /stock_cargos/1.xml
  def show
    @stock_cargo = StockCargo.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_cargo }
    end
  end

  # GET /stock_cargos/new
  # GET /stock_cargos/new.xml
  def new
    @stock_cargo = StockCargo.new
    @user=User.find_by_id(session[:user_id])
    @stock_cargo.user_id=@user.id
    @stock_cargo.company_id=@user.company_id unless @user.company_id.nil?
    @stock_cargo.status="闲置"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock_cargo }
    end
  end

  # GET /stock_cargos/1/edit
  def edit
    @stock_cargo = StockCargo.find(params[:id])
  end

  # POST /stock_cargos
  # POST /stock_cargos.xml
  def create
    # result= get_stock_cargo_from_params(params)
    #  @stock_cargo = StockCargo.new(params)
    params[:stockcargo][:cargocount]=0 #init value
    @stock_cargo = StockCargo.new(params[:stockcargo])    
    respond_to do |format|
      if @stock_cargo.save
        flash[:notice] = '货物创建成功！.'
        @ustatistic=Ustatistic.find_by_user_id(session[:user_id])
        total_stock_cargo=@ustatistic.total_stock_cargo || 0
        @ustatistic.update_attributes({:total_stock_cargo=>total_stock_cargo+1})
        format.html { redirect_to(@stock_cargo) }
        format.xml  { render :xml => @stock_cargo, :status => :created, :location => @stock_cargo }
      else
        flash[:notice] = '货物创建失败！.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @stock_cargo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stock_cargos/1
  # PUT /stock_cargos/1.xml
  def update    
    @stock_cargo = StockCargo.find(params[:id])
    respond_to do |format|
      if @stock_cargo.update_attributes(params[:stock_cargo])
        flash[:notice] = '货物更新成功.'
        format.html { redirect_to(@stock_cargo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_cargo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_cargos/1
  # DELETE /stock_cargos/1.xml
  def destroy
    @stock_cargo = StockCargo.find(params[:id])
    @stock_cargo.destroy

    respond_to do |format|
      format.html { redirect_to(stock_cargos_url) }
      format.xml  { head :ok }
    end
  end
end
