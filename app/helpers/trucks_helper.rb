 # coding: utf-8
module TrucksHelper
  include FileUtils
  def get_truck_info_from_params(params)

  params[:truck][:user_id]=session[:user_id]
  begin
  @truck = Truck.create!(params[:truck])
  rescue
    raise
    return nil
  end
   return @truck
end

  def update_truck_info_from_params(params)

    if  @truck
       @truck.update_attributes( params[:truck])
      return @truck
    else
      return nil
    end

  end
  # This is for view cache purpose
def get_search_truck(fcity_code,tcity_code)    
 if fcity_code=="100000000000" && tcity_code=="100000000000" then   
     @trucks=Truck.where(:status=>"正在配货").sort(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
   elsif fcity_code=="100000000000" && tcity_code!="100000000000"
      result=get_max_min_code(tcity_code)
      min=result[0]
      max=result[1]
      if result[2]
        @trucks=Truck.where({:tcity_code=>min,:status=>"正在配货"}).
                       sort(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
      else
         @trucks=Truck.where({:tcity_code.gte=>min,:tcity_code.lt=>max,:status=>"正在配货"}).
                       sort(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
      end
    elsif tcity_code=="100000000000" && fcity_code!="100000000000"
     result=get_max_min_code(fcity_code)
     min=result[0]
     max=result[1]
     if result[2]
       @trucks=Truck.where({:fcity_code =>min,:status=>"正在配货"}).
                          sort(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
     else
       @trucks=Truck.where({:fcity_code.gte =>min,:fcity_code.lt =>max,:status=>"正在配货"}).
                          sort(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20)
     end
 
    else
     resultt=get_max_min_code(tcity_code)
     resultf=get_max_min_code(fcity_code)
      mint=resultt[0]
      maxt=resultt[1]
      minf=resultf[0]
      maxf=resultf[1]
    #  puts "mint=#{mint}, maxt=#{maxt},minf=#{minf},maxf=#{maxf}"
      if resultt[2]==false && resultf[2]==false
      #  puts "两个都不是县级市"
          @trucks=Truck.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配货"}).
                                 sort(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20 )
       elsif resultt[2]==true && resultf[2]==false
       #   puts "到达是县级市"
          @trucks=Truck.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code=>mint,:status=>"正在配货"}).
                                 sort(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20 )
       elsif resultt[2]==false && resultf[2]==true
        #   puts "出发是县级市"
          @trucks=Truck.where({:fcity_code =>minf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配货"}).
                                 sort(:updated_at.desc).paginate(:page=>params[:page]||1,:per_page=>20 )
       else
       #  puts "两个都是县级市"
          @trucks=Truck.where({:fcity_code =>minf,:tcity_code=>mint,:status=>"正在配货"}).
                                 sort(:updated_at.desc).all.paginate(:page=>params[:page]||1,:per_page=>20 )
      end
    end    
  end
  
  def cal_expire_city(from_city,to_city)   
     lines=Array.new
    if (from_city!="100000000000" && to_city!="100000000000")
    lines<<[from_city,to_city] #expire city to city 
    lines<<[from_city.slice(0,4)+"00000000",to_city] #expire region to city
    lines<<[from_city.slice(0,2)+"0000000000",to_city] #province to city
    lines<<["100000000000",to_city] #expire anywhere  to city  
    lines<<["100000000000",to_city.slice(0,4)+"00000000"] #expire anywhere  to region  
    lines<<["100000000000",to_city.slice(0,2)+"0000000000"] #expire anywhere to province  
     
    lines<<[from_city,to_city.slice(0,4)+"00000000"] #city to region
    lines<<[from_city,to_city.slice(0,2)+"0000000000"] #city  to province
    lines<<[from_city,"100000000000"]  #expire city to anywhere
    lines<<[from_city.slice(0,4)+"00000000","100000000000"]  #expire region to anywhere
    lines<<[from_city.slice(0,2)+"0000000000","100000000000"]  #expire province to anywhere
    
   lines<<[from_city.slice(0,4)+"00000000",to_city.slice(0,4)+"00000000"] #expire region to region 
   lines<<[from_city.slice(0,2)+"0000000000",to_city.slice(0,2)+"0000000000"] #expire province to province 
   lines<<[from_city.slice(0,4)+"00000000",to_city.slice(0,2)+"0000000000"] #expire region to province 
   lines<<[from_city.slice(0,2)+"0000000000",to_city.slice(0,4)+"00000000"] #expire province  to region   
  
   all_lines=lines.uniq
   
    all_lines
  end
 end
 def iterate_expire_line(line,from_city,to_city)
      line =line+cal_expire_city(from_city,to_city)
      line=line.uniq
      line
 end
    
 def expire_line_truck(from_city,to_city)   
   all_lines=cal_expire_city(from_city,to_city)   
  
   #rm folder
   all_lines.each do |line|
     FileUtils.rm_rf Rails.public_path+"/trucks/search"+"/#{line[0]}"+"/#{line[1]}"       
     Rails.logger.debug "expire "+Rails.public_path+"/trucks/search"+"/#{line[0]}"+"/#{line[1]}"
   end

  end



end
