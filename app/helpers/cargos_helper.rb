 # coding: utf-8
 


module CargosHelper
    include FileUtils
 def get_max_min_code(code)
    max_code,min_code=0

   if code.match(/\d\d0000000000$/) # is a province id 
         max_code=(code.to_i+10000000000).to_s     
         min_code=code
         iscity=false
   elsif code.match(/\d\d\d\d00000000$/)  and (not code.match(/\d\d0000000000$/))  # is a region
        iscity=false
        max_code=(code.to_i+100000000).to_s
        min_code=code
   else
       iscity=true
       max_code=code
       min_code=code
   end
  # puts "code=#{code},min_code=#{min_code},max_code=#{max_code},iscity=#{iscity}"
   [min_code,max_code,iscity]   
  end

 #for view storage purpose, but now use page cache 
 def get_search_cargos(fcity_code,tcity_code)
   
   if fcity_code=="100000000000" && tcity_code=="100000000000" then
       @cargos=Cargo.where(:status=>"正在配车").desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>20)
    elsif fcity_code=="100000000000" && tcity_code!="100000000000"
      result=get_max_min_code(tcity_code)
      min=result[0]
      max=result[1]
      if result[2]
        @cargos=Cargo.where({:tcity_code=>min,:status=>"正在配车"}).desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>20)
      else
        @cargos=Cargo.where({:tcity_code.gte=>min,:tcity_code.lt=>max,:status=>"正在配车"}).desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>20)
       end
     elsif tcity_code=="100000000000" && fcity_code!="100000000000"
      result=get_max_min_code(fcity_code)
      min=result[0]
      max=result[1]
      if result[2]
        @cargos=Cargo.where({:fcity_code=>min,:status=>"正在配车"}).desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>20)
      else
        @cargos=Cargo.where({:fcity_code.gte =>min,:fcity_code.lt =>max,:status=>"正在配车"}).desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>20)
      end
    else
   
     resultt=get_max_min_code(tcity_code)
      mint=resultt[0]
      maxt=resultt[1]
    
     resultf=get_max_min_code(fcity_code)
      minf=resultf[0]
      maxf=resultf[1]

    #  puts "mint=#{mint}, maxt=#{maxt},minf=#{minf},maxf=#{maxf},resultt[2]=#{resultt[2]},resultf=#{resultf[2]}"
      if resultt[2]==false && resultf[2]==false  
        @cargos=Cargo.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配车"}).desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>20)
      elsif resultt[2]==true && resultf[2]==false  
        @cargos=Cargo.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code=>mint,:status=>"正在配车"}).desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>20)
      elsif resultt[2]==false && resultf[2]==true
        @cargos=Cargo.where({:fcity_code=>minf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配车"}).desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>20)
      else
        @cargos=Cargo.where(:fcity_code =>minf,:tcity_code=>mint,:status=>"正在配车").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
        end
    end
    @cargos
 end
 
 def expire_line_cargo(from_city,to_city)   
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
  
   #rm folder
   all_lines.each do |line|
     FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"       
     Rails.logger.debug "expire "+Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"
   end
  else
    #only expire first page, others only Cargos.count/ % 20 ==0 to expire
    # if Cargo.count % 20 ==0
    #    FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"   
    # else
   #     FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}/1.html"       
   #  end
    end
 end



end
