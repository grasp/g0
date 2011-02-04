# coding: utf-8

class CargosController < ApplicationController
 # include Soku
  # GET /cargos
  # GET /cargos.xml
  include CargosHelper
  before_filter:authorize, :except => [:search,:show]
  protect_from_forgery :except => [:tip,:login]
  layout nil
  #
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
    if params[:search].nil?      
      unless params[:fcity_code].blank?
        @search.fcity_code=params[:fcity_code]
         @search.fcity_name=$city_code_name[params[:fcity_code]]
     else
        @search.fcity_code="100000000000"
        @search.fcity_name="出发地选择"
     end
     unless params[:fcity_code].blank?
        @search.tcity_code=params[:tcity_code];@search.tcity_name=$city_code_name[params[:tcity_code]] 
     else
         @search.tcity_name="到达地选择"
         @search.tcity_code="100000000000"
     end
    else
      @search.fcity_name=params[:search][:fcity_name]
      @search.tcity_name=params[:search][:tcity_name]
      @search.fcity_code=params[:search][:fcity_code]
      @search.tcity_code=params[:search][:tcity_code]
    end
    
    puts "@search.fcity_code=#{@search.fcity_code},@search.tcity_code=#{@search.tcity_code}";

    if @search.fcity_code=="100000000000" && @search.tcity_code=="100000000000" then
       @cargos=Cargo.where(:status=>"正在配车").order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    elsif @search.fcity_code=="100000000000" && @search.tcity_code!="100000000000"
      result=get_max_min_code(@search.tcity_code)
      min=result[0]
      max=result[1]
      if result[2]
        @cargos=Cargo.where({:tcity_code=>min,:status=>"正在配车"}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
      else
        @cargos=Cargo.where({:tcity_code.gte=>min,:tcity_code.lt=>max,:status=>"正在配车"}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
       end
     elsif @search.tcity_code=="100000000000" && @search.fcity_code!="100000000000"
      result=get_max_min_code(@search.fcity_code)
      min=result[0]
      max=result[1]
      if result[2]
        @cargos=Cargo.where({:fcity_code=>min,:status=>"正在配车"}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
      else
        @cargos=Cargo.where({:fcity_code.gte =>min,:fcity_code.lt =>max,:status=>"正在配车"}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
      end
    else
   
     resultt=get_max_min_code(@search.tcity_code)
      mint=resultt[0]
      maxt=resultt[1]
    
     resultf=get_max_min_code(@search.fcity_code)
      minf=resultf[0]
      maxf=resultf[1]

      puts "mint=#{mint}, maxt=#{maxt},minf=#{minf},maxf=#{maxf},resultt[2]=#{resultt[2]},resultf=#{resultf[2]}"
      if resultt[2]==false && resultf[2]==false
  
        @cargos=Cargo.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配车"}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
      elsif resultt[2]==true && resultf[2]==false
  
        @cargos=Cargo.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code=>mint,:status=>"正在配车"}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
      elsif resultt[2]==false && resultf[2]==true

        @cargos=Cargo.where({:fcity_code=>minf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配车"}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
      else
          @cargos=Cargo.where(:fcity_code =>minf,:tcity_code=>mint,:status=>"正在配车").sort(:created_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
      # @cargos=Cargo.where(:fcity_code =>minf,:tcity_code=>mint,:status=>"正在配车").all.paginate(:page=>params[:page]||1,:per_page=>20)


      end
    end
    @search.save
    
  end


  def index

    unless params[:stock_cargo_id].nil?
       @cargos=Cargo.where({user_id =>session[:user_id], :stock_cargo_id =>params[:stock_cargo_id]}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    else
    if params[:status]
        @cargos = Cargo.where(:user_id =>session[:user_id],:status =>params[:status]).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    else
      #  @cargos = Cargo.where("user_id = ?",session[:user_id]).order("updated_at desc").paginate(:page=>params[:page]||1,:per_page=>20)
       @cargos = Cargo.where(:user_id =>session[:user_id]).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
      end
    end    
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargos }
    end   
  end
  
  def match
      @cargo = Cargo.find_by_id(params[:cargo_id])
      @search=Search.new
      @search.fcity_name=@cargo.fcity_name
      @search.tcity_name=@cargo.tcity_name
      @search.fcity_code=@cargo.fcity_code
      @search.tcity_code=@cargo.tcity_code
      
     # @trucks=Truck.where(:fcity_code =>@cargo.fcity_code,:tcity_code =>@cargo.tcity_code).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    if @search.fcity_code=="100000000000" && @search.tcity_code=="100000000000" then   
     @trucks=Truck.where.order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   elsif @search.fcity_code=="100000000000" && @search.tcity_code!="100000000000"
     min=get_max_min_code(@search.tcity_code)[0]
     max=get_max_min_code(@search.tcity_code)[1]
      @trucks=Truck.where({:tcity_code.gte=>min,:tcity_code.lt=>max,:status=>"配货"}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    elsif @search.tcity_code=="100000000000" && @search.fcity_code!="100000000000"
     min=get_max_min_code(@search.fcity_code)[0]
     max=get_max_min_code(@search.fcity_code)[1]     
     @trucks=Truck.where({:fcity_code.gte =>min,:fcity_code.lt =>max,:status=>"配货"}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    else
      mint=get_max_min_code(@search.tcity_code)[0]
      maxt=get_max_min_code(@search.tcity_code)[1]
      minf=get_max_min_code(@search.fcity_code)[0]
      maxf=get_max_min_code(@search.fcity_code)[1]
     @trucks=Truck.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"配货"}).order(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
    end
    @search.save
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargo }
    end

  end

  def part
    @stock_cargo = StockCargo.find_by_id(params[:stock_cargo_id])
    @cargos=Cargo.where({:stock_cargo_id => params[:stock_cargo_id],:user_id =>session[:user_id]}).paginate(:page=>params[:page]||1,:per_page=>20)
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
    puts "@stock_cargo=nil" if @stock_cargo.blank?
    puts "@stock_cargo.cate_name=#{@stock_cargo.cate_name}"
    @cargo.stock_cargo_id=@stock_cargo.id
    @user=User.find_by_id(session[:user_id])
    @cargo.user_id=@user.id    
    @cargo.status="正在配车"

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
     params[:cargo][:from_site]="local"
 
    @cargo=Cargo.new(params[:cargo])
  
    # @cargo=get_cargo_info_from_params(params)
    @cargo.line=@cargo.fcity_code+"#"+@cargo.tcity_code
  
    respond_to do |format|
      if @cargo.save
        flash[:notice] = '创建货源成功！'
        @cstatistic=Cstatistic.create(:total_baojia=>0,:total_xunjia=>0,:total_match=>0,
          :total_click=>0,:user_id=>session[:user_id],:cargo_id=>@cargo.id);
        #update statistic for cargo
        #update need use mongo way to avoid use model method
  
        Cargo.collection.update({'_id' => @cargo.id},{'$set' =>{:cstatistic_id=>@cstatistic.id}})
        Ustatistic.collection.update({'user_id' => session[:user_id]},{'$inc' => {"total_cargo" => 1,"cargopeiche"=>1},'$set' => {"status"=>"正在配车"}},{:upsert =>true})
        Lstatistic.collection.update({'line'=>@cargo.line},{'$inc' => {"total_cargo" => 1,"cargopeiche"=>1},'$set' => {"status"=>"正在配车"}},{:upsert =>true})
        StockCargo.collection.update({'_id' => @cargo.stock_cargo_id},{'$inc' => {"cargocount" => 1,"cargopeiche"=>1},'$set' => {"status"=>"正在配车"}})

        format.html { redirect_to(@cargo)}
        format.xml  { render :xml => @cargo, :status => :created, :location => @cargo }
      else
        flash[:notice] = '创建货源失败'
        @stock_cargo=StockCargo.find_by_id(@cargo.stock_cargo_id)
        format.html { render :controller=>"cargos",:action => "new" }
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
      #update may fail due to
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
