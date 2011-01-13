# coding: utf-8
class CargosController < ApplicationController
  # GET /cargos
  # GET /cargos.xml
  include CargosHelper
  before_filter:authorize, :except => [:search]
  protect_from_forgery :except => [:tip,:login]
  layout nil
  
  def public
    #if this is all    
    if params[:city_from].nil?
      @cargos = Cargo.paginate(:page=>params[:page]||1,:per_page=>20)
    else
      @cargos=nil
    end

    # if this is line search

    #render view here
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargo }
    end

  end

  def search
    @search=Search.new
    if params[:search].nil? then

      @search.fcity_name="全国"
      @search.tcity_name="全国"
      @search.fcity_code="100000000000"
      @search.tcity_code="100000000000"
    else
      @search.fcity_name=params[:search][:fcity_name]
      @search.tcity_name=params[:search][:tcity_name]
      @search.fcity_code=params[:search][:fcity_code]
      @search.tcity_code=params[:search][:tcity_code]
    end

    if @search.fcity_code=="100000000000" && @search.tcity_code=="100000000000" then
       @cargos=Cargo.where(:status=>"配车").order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)

    elsif @search.fcity_code=="100000000000" && @search.tcity_code!="100000000000"
      @cargos=Cargo.where({:tcity_code =>@search.tcity_code,:status=>"配车"}).order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)

    elsif params[:search][:tcity_code]=="100000000000" && params[:search][:fcity_code]!="100000000000"
      @cargos=Cargo.where({:fcity_code =>@search.fcity_code,:status=>"配车"}).order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
    else
      @cargos=Cargo.where({:tcity_code =>@search.tcity_code, :fcity_code =>@search.fcity_code ,:status=>"配车"}).order(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
    end

    @search.save
  end


  def index

    unless params[:stock_cargo_id].nil?
       @cargos=Cargo.where({user_id =>session[:user_id], :stock_cargo_id =>params[:stock_cargo_id]}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    else
      if params[:status]
        @cargos = Cargo.where(:user_id =>session[:user_id],:status =>params[:status]).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
    else
      #  @cargos = Cargo.where("user_id = ?",session[:user_id]).order("updated_at desc").paginate(:page=>params[:page]||1,:per_page=>10)
       @cargos = Cargo.where(:user_id =>session[:user_id]).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
      end
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargos }
    end   
  end
  
  def match
    @cargo = Cargo.find_by_id(params[:cargo_id])
        @trucks=Truck.where(:fcity_code =>@cargo.fcity_code,:tcity_code =>@cargo.tcity_code).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>10)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargo }
    end

  end

  def part
    @stock_cargo = StockCargo.find_by_id(params[:stock_cargo_id])
    @cargos=Cargo.where({:stock_cargo_id => params[:stock_cargo_id],:user_id =>session[:user_id]}).paginate(:page=>params[:page]||1,:per_page=>10)
    respond_to do |format|
      format.html # part.html.erb
      format.xml  { render :xml => @cargos }
    end

  end
  # GET /cargos/1
  # GET /cargos/1.xml
  def show
    @cargo = Cargo.find(params[:id])
    @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
    @line_ad=LineAd.find({:line=>get_line(@cargo.fcity_code,@cargo.tcity_code)})
    
    if @line_ad.blank?
      #@line_ad=LineAd.find_by_line("0")
      #@line_ad.fcity_name=@cargo.fcity_name
      #@line_ad.tcity_name=@cargo.tcity_name
    end
    # @user_contact=ContactPerson.find_by_id(@cargo.user_id)
    #  @company=Company.find_by_id(@cargo.company_id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargo }
    end
  end

  # GET /cargos/new
  # GET /cargos/new.xml
  def new
    #check conact first
    @cargo = Cargo.new
    @stock_cargo=StockCargo.find_by_id(params[:id])
    @cargo.stock_cargo_id=@stock_cargo.id
    @user=User.find_by_id(session[:user_id])
    @cargo.user_id=@user.id    
    @cargo.status="配车"

    @user_contact=UserContact.find_by_user_id(session[:user_id])
    @cargo.user_contact_id=@user_contact.id unless @user_contact.nil?

    if @user_contact.blank?
      flash[:notice]="发布货源必须要知道你的联系方式和姓名."
      render(:template=>"shared/new_contact")
      return;
    end
    @company=Company.find_by_user_id(@user.id)
    @cargo.company_id=@company.id unless @company.nil?

    if @company.blank?
      flash[:notice]="你的公司信息没有填写"
      render(:template=>"shared/new_company")
      return;
    end

    respond_to do |format|

      format.html # new.html.erb
      format.xml  { render :xml => @cargo }
    end

  end

  # GET /cargos/1/edit
  def edit
    @cargo = Cargo.find(params[:id])
    if @cargo.nil?
      puts "你编辑了一个空的"
    end
    @stock_cargo=StockCargo.find_by_id(@cargo.stock_cargo_id)

  end

  # POST /cargos
  # POST /cargos.xml
  def create
    @cargo=Cargo.new(params[:cargo])
    # @cargo=get_cargo_info_from_params(params)
    @cargo.line=@cargo.fcity_code+"#"+@cargo.tcity_code

  
    respond_to do |format|
      if @cargo.save
        flash[:notice] = '创建货源成功！'
        @cstatistic=Cstatistic.create(:total_baojia=>0,:total_xunjia=>0,:total_match=>0,
          :total_click=>0,:user_id=>session[:user_id]);
        #update statistic for cargo
        @cargo.update_attributes({:cstatistic_id=>@cstatistic.id})
        @ustatistic=Ustatistic.find_by_user_id(session[:user_id])
        total_cargo=@ustatistic.total_cargo || 0
        @ustatistic.update_attributes({:total_cargo=>total_cargo+1})

        #update lstastistic info
        @lstatistic=Lstatistic.find_by_line(@cargo.line)
        if @lstatistic.nil?
          Lstatistic.create(:line=>@cargo.line,:valid_cargo=>1,:valid_truck=>0,:total_cargo=>1,:total_truck=>0)
        else
          @lstatistic.update_attributes(:valid_cargo=>(@lstatistic.valid_cargo ||0)+1,:total_cargo=>(@lstatistic.total_cargo ||0)+1)
        end

        #update stock  cargo status
        @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
              
        StockCargo.collection.update({"_id" => @stock_cargo.id}, {:status=>"配车"},{"$inc" => {"cargocount" => 1}})
        
        format.html { redirect_to(@cargo)}
        format.xml  { render :xml => @cargo, :status => :created, :location => @cargo }
      else
        flash[:notice] = '创建货源失败'
        format.html { render :action => "new" }
        format.xml  { render :xml => @cargo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cargos/1
  # PUT /cargos/1.xml
  def update
    
    @cargo = Cargo.find(params[:id])
    @stock_cargo=StockTruck.find_by_id(@cargo.stock_cargo_id)

    #  @cargo =update_cargo_info_from_params(params)
    
    respond_to do |format|
      if   @cargo.update_attributes( params[:cargo])
        flash[:notice] = '货源更新成功'
        format.html { redirect_to(@cargo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cargo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def chenjiao

  end

  # DELETE /cargos/1
  # DELETE /cargos/1.xml
  def destroy
    @cargo = Cargo.find(params[:id])
    @cargo.destroy

    respond_to do |format|
      format.html { redirect_to(cargos_url) }
      format.xml  { head :ok }
    end
  end
end
