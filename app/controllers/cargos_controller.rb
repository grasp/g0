# coding: utf-8

class CargosController < ApplicationController
  # include Soku
  # GET /cargos
  # GET /cargos.xml
  include CargosHelper
   before_filter:authorize, :except => [:search,:show]
   before_filter:authorize_public, :only => [:search]
 # caches_page :search,:show
   protect_from_forgery :except => [:tip,:login]
   layout 'public' ,:except => [:show,:search]

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
      unless params[:from].blank?
         @search.fcity_code=params[:from]
         @search.fcity_name=$city_code_name[params[:from]]
     else
        @search.fcity_code="100000000000"
        @search.fcity_name="出发地选择"
     end
     unless params[:to].blank?
        @search.tcity_code=params[:to]
        @search.tcity_name=$city_code_name[params[:to]] 
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

    #puts "@search.fcity_code=#{@search.fcity_code},@search.tcity_code=#{@search.tcity_code}";
    @line=@search.fcity_code+"#"+@search.tcity_code
  #  @action_suffix="#{@line}#{params[:page]}"        
    @search.save
    
    respond_to do |format|
    if params[:layout]     
      format.html  
    else
     format.html {render :layout=>"public"}
    end
    end
  end

  def quoteinquery
   # @cargo=Cargo.find(params[:cargo_id])
   @cargo=Cargo.find(params[:cargo_id])

    @xunjia=Inquery.where(:cargo_id => params[:cargo_id])
    @baojia=Quote.where(:cargo_id => params[:cargo_id])
  end
  
  def index


    unless params[:stock_cargo_id].blank?
       @cargos=Cargo.where({:user_id =>session[:user_id], :stock_cargo_id =>params[:stock_cargo_id]}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    else
    if params[:status]=="peiche"
        @cargos = Cargo.where(:user_id =>session[:user_id],:status =>"正在配车").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    elsif params[:status]=="ischenjiao"
       @cargos = Cargo.where(:user_id =>session[:user_id],:status =>"正在成交").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    elsif params[:status]=="chenjiao"
       @cargos = Cargo.where(:user_id =>session[:user_id],:status =>"已成交").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
     else
       #@cargos = Cargo.where("user_id = ?",session[:user_id]).order("updated_at desc").paginate(:page=>params[:page]||1,:per_page=>20)
       @cargos = Cargo.where(:user_id =>session[:user_id]).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    end
   end    
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargos }
    end   
  end
  
  def match
    #  @cargo = Cargo.find(params[:cargo_id])
    @cargo = Cargo.find(params[:cargo_id])
      @search=Search.new
      @search.fcity_name=@cargo.fcity_name
      @search.tcity_name=@cargo.tcity_name
      @search.fcity_code=@cargo.fcity_code
      @search.tcity_code=@cargo.tcity_code
      
     # @trucks=Truck.where(:fcity_code =>@cargo.fcity_code,:tcity_code =>@cargo.tcity_code).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    if @search.fcity_code=="100000000000" && @search.tcity_code=="100000000000" then   
     @trucks=Truck.where.desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
   elsif @search.fcity_code=="100000000000" && @search.tcity_code!="100000000000"
     min=get_max_min_code(@search.tcity_code)[0]
     max=get_max_min_code(@search.tcity_code)[1]
      @trucks=Truck.where({:tcity_code.gte=>min,:tcity_code.lt=>max,:status=>"配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    elsif @search.tcity_code=="100000000000" && @search.fcity_code!="100000000000"
     min=get_max_min_code(@search.fcity_code)[0]
     max=get_max_min_code(@search.fcity_code)[1]     
     @trucks=Truck.where({:fcity_code.gte =>min,:fcity_code.lt =>max,:status=>"配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    else
      mint=get_max_min_code(@search.tcity_code)[0]
      maxt=get_max_min_code(@search.tcity_code)[1]
      minf=get_max_min_code(@search.fcity_code)[0]
      maxf=get_max_min_code(@search.fcity_code)[1]
     @trucks=Truck.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    end
    @search.save
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargo }
    end

  end

  def part
   # @stock_cargo = StockCargo.find(params[:stock_cargo_id])
   @stock_cargo = StockCargo.find(params[:stock_cargo_id])
    @cargos=Cargo.where({:stock_cargo_id => params[:stock_cargo_id],:user_id =>session[:user_id]}).paginate(:page=>params[:page]||1,:per_page=>20)
    respond_to do |format|
      format.html # part.html.erb
      format.xml  { render :xml => @cargos }
    end
  end
  # GET /cargos/1
  # GET /cargos/1.xml
  def show
   # @cargo = Cargo.find(params[:id].to_s) #why not work ????
   @cargo = Cargo.first(:conditions=>{:_id=>params[:id].to_s})
   @stock_cargo=StockCargo.find(@cargo.stock_cargo_id) if @cargo.from_site=="local"  && !@cargo.stock_cargo_id.blank?
  #  @line_ad=LineAd.find({:line=>get_line(@cargo.fcity_code,@cargo.tcity_code)})    
    if @line_ad.blank?
      #@line_ad=LineAd.find_by_line("0")
      #@line_ad.fcity_name=@cargo.fcity_name
      #@line_ad.tcity_name=@cargo.tcity_name
    end
    # @user_contact=ContactPerson.find(@cargo.user_id)
    #  @company=Company.find(@cargo.company_id)
    
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
    @stock_cargo=StockCargo.find(BSON::ObjectId(params[:id]))
    @cargo .stock_cargo_id=@stock_cargo.id
    @user=User.find(session[:user_id])

    @cargo.user_id=@user.id
    @cargo.status="正在配车"
   @cargo.stock_cargo_id=@stock_cargo.id

    if @user.user_contact_id.blank?
      flash[:notice]="填写更多的联系信息，可以增加成交机会"
    end
    if @user.company_id.blank?
      if flash[:notice].blank?
              flash[:notice]="填写公司信息能够增加成交机会"
      else
              flash[:notice]<<";填写公司信息能够增加成交机会"
      end

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
   # @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
   @stock_cargo=@cargo.stock_cargo

  end

  # POST /cargos
  # POST /cargos.xml
  def create
     params[:cargo][:from_site]="local"
    # @stock_cargo=StockCargo.find(BSON::ObjectId(params[:cargo][:stock_cargo_id]))
    # @cargo.stock_cargo_id=
     params[:cargo][:stock_cargo_id]=BSON::ObjectId(params[:cargo][:stock_cargo_id])
     @user=User.find(session[:user_id])
     @cargo=Cargo.new(params[:cargo])
     @cargo.user_contact_id=UserContact.find(@user.user_contact_id) unless @user.user_contact_id .nil?
     @cargo.company_id=Company.find(@user.company_id) unless @user.company_id .nil?
     @cargo.user_id=@user.id
     @cargo.line=@cargo.fcity_code+"#"+@cargo.tcity_code

    respond_to do |format|
      if @cargo.save
        flash[:notice] = '创建货源成功！'
        @cargo.update_attributes(:total_baojia=>0,:total_xunjia=>0,:total_match=>0,
          :total_click=>0,:user_id=>session[:user_id],:cargo_id=>@cargo.id);
        #update statistic for cargo
        #update need use mongo way to avoid use model method
        #be carefull when use foreign object_id,otherwise ,will not update !!!!
      #  Ustatistic.collection.update({:user_id => BSON::ObjectId(session[:user_id].to_s)}, {'$set' => {:status=>"正在配车"}})
       # Ustatistic.collection.update({:user_id => BSON::ObjectId(session[:user_id].to_s)},{'$inc' => {:total_cargo =>1,:valid_cargo=>1}})
       begin
       ustatistic= Ustatistic.find(  @user.ustatistic_id)
       rescue
       end
       unless ustatistic.blank?
       logger.info  "inc cargo ustatisc"
         ustatistic.update_attributes(:status=>"正在配车")
         ustatistic.inc(:total_cargo,1)
         ustatistic.inc(:valid_cargo,1)
       else
         Ustatistic.create("user_id"=>session[:user_id],:status=>"正在配车",:total_cargo =>1,:valid_cargo=>1)
   logger.info  "create ustatisc for cargo create"
       end
       # Lstatistic.collection.update({:line=>@cargo.line},{'$set' =>{:status=>"正在配车"}});
       # Lstatistic.collection.update({:line=>@cargo.line},{'$inc' => {:total_cargo =>1,:valid_cargo=>1}})
       @lstatistic=Lstatistic.where(:line=>@cargo.line).first
       unless @lstatistic.nil?
        @lstatistic.inc(:total_cargo,1)
        @lstatistic.inc(:valid_cargo,1)
       else
         Lstatistic.create(:line=>@cargo.line,:total_cargo =>1,:valid_cargo=>1)
       end
      
        
        #$inc and $set could not be used together !!!!!!!???
        # $db[:stock_cargos].update({'_id' => @cargo.stock_cargo_id},{'$inc' =>{"valid_cargo" =>1},'$set' =>{"status"=>"正在配车"}})
       # StockCargo.collection.update({:_id => @cargo.stock_cargo_id},{'$set' =>{:status=>"正在配车"}})
        @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
        @stock_cargo.update_attributes(:status=>"正在配车")
        @stock_cargo.inc(:valid_cargo,1)
        @stock_cargo.inc(:total_cargo,1)
        @stock_cargo.inc(:sent_weight,@cargo.cargo_weight.to_f)
        @stock_cargo.inc(:sent_bulk,@cargo.cargo_bulk.to_f)
       
       # StockCargo.collection.update({:_id => @cargo.stock_cargo_id},
       #  {'$inc'=>{:valid_cargo=>1,:total_cargo=>1,:sent_weight=>@cargo.cargo_weight.to_f,:sent_bulk=>@cargo.cargo_bulk.to_f}},{:upsert =>true})
      
        format.html { redirect_to :action => "index"}
      #  format.xml  { render :xml => @cargo, :status => :created, :location => @cargo }
      else
        flash[:notice] = '创建货源失败,重复发布货源'
       # @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
        format.html { render :template=>"/cargos/repeat_error" }
        format.xml  { render :xml => @cargo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cargos/1
  # PUT /cargos/1.xml
  def update
    
    @cargo = Cargo.find(params[:id])
    @stock_cargo=StockTruck.find(@cargo.stock_cargo_id)

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
    cargo = Cargo.find(BSON::ObjectId(params[:id]))
    cargo.destroy if cargo

    #do we need update the statisitc?
   # url=request.url
   @user=User.find(session[:user_id])
    respond_to do |format|
      if @user.name=="admin"
      format.html { redirect_to(admincargo_manage_path) }
      else
       format.html { redirect_to(root_path) }
      end
      format.xml  { head :ok }
    end
  end
end
