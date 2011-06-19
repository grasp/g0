module AdminHelper
  #get a stupid map at first
  $table_map={
    "cargo"=>Cargo,
    "truck"=>Truck,
    "stocktruck"=>StockTruck,
    "stockcargo"=>StockCargo,
    "user"=>User,
    "company"=>Company,
    "quote"=>Quote,
    "inquery"=>Inquery
  }

  def show_daily_trends
    start_time=Time.now
    @trends=Hash.new
    @title=params[:table]
    @max=0
    (params[:day].to_i).downto(1).each do |i|
      begin_time=(start_time-(86400*(i-1))).at_midnight()
      end_time=begin_time-86400
      if params[:field]
        counter=$table_map[params[:table]].where(:created_at.gt => end_time,:created_at.lte=>begin_time,params[:field]=>params[:value]).count
      else
        counter=$table_map[params[:table]].where(:created_at.gt => end_time,:created_at.lte=>begin_time).count
      end
      #counter=100
      @trends[begin_time.to_s]=counter
      @max=@trends[begin_time.to_s] if @max<counter
    end
    #sort
    @trends=@trends.to_a.reverse!
  end

  def show_hourly_trends
    start_time=(Time.parse(params[:day])+86400).at_midnight
    @trends=Hash.new
    @title=params[:table]
    @max=0
    (24).downto(1).each do |i|
      begin_time=(start_time-(3600*(i-1)))
      end_time=begin_time-3600
      if params[:field]
        counter=$table_map[params[:table]].where(:created_at.gt => end_time,:created_at.lte=>begin_time,params[:field]=>params[:value]).count
      else
        counter=$table_map[params[:table]].where(:created_at.gt => end_time,:created_at.lte=>begin_time).count
      end
      #counter=100
      @trends[begin_time.to_s]=counter
      @max=@trends[begin_time.to_s] if @max<counter
    end
    #sort
    @trends=@trends.to_a.reverse!
  end
  def helper_request_log_analysis

    @all_log_file=Array.new
    Dir.new(File.join(Rails.root,"log")).each {|file| @all_log_file<<file}
    @all_log_file.delete(".")
    @all_log_file.delete("..")
    @all_log_file.each {|logfile| logfile=logfile.gsub!(/\./,"#").to_s}

    if  params[:logfile].nil?
      params[:logfile]="production"+Time.now.to_s.slice(0,10)+".log"
    else
      a=params[:logfile].to_s
      params[:logfile]= a.gsub!(/#/,".").to_s #rails uri can not parse .
    end
    $production_log=File.join(Rails.root,"log",params[:logfile])
    unless File.exist?($production_log)
      params[:logfile]="development"+Time.now.to_s.slice(0,10)+".log" if  params[:logfile].nil?
      $production_log=File.join(Rails.root,"log",params[:logfile])
    end
    unless File.exist?($production_log)
      params[:logfile]="development.log" if  params[:logfile].nil?
      $production_log=File.join(Rails.root,"log",params[:logfile])
    end

    if params[:all]
      @all_log_file=Array.new
      Dir.new(File.join(Rails.root,"log")).each {|file| @all_log_file<<file}
      @all_log_file.delete(".")
      @all_log_file.delete("..")
      $production_log=String.new
      @all_log_file.each do |file|
        $production_log<<" "+File.join(Rails.root,"log",file)
      end
    else
      $production_log<<" "+File.join(Rails.root,"log",params[:logfile])
    end
    @command="request-log-analyzer #{$production_log} --output html"
    @analysis =`request-log-analyzer #{$production_log} --output html`


  end

  def show_log_helper
    if params[:logfile]
   @logfile=params[:logfile]
   @logfile.gsub!(/#/,".")
    else
      @logfile='/var/log/cron.log'
    end
   logs=`cat #{@logfile}`
   @logs=Array.new
   @logs=logs.split("\n")
  end
end
