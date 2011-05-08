 # coding: utf-8
module CitiesHelper
  def get_city_array(code)    
 
    if code.match(/\d\d0000000000$/) # is a province id  
       @selected_city_name= $province_region[code]
       @province_code=code
       @region=$citytree[@province_code]
      
    elsif code.match(/\d\d\d\d00000000$/)  and (not code.match(/\d\d0000000000$/))
       @selected_city_name= $province_region[code.slice(0,2)+"0000000000"]+$province_region[code]
       @province_code=code.slice(0,2)+"0000000000"
       @region_code=code  
       @region=$citytree[@province_code]
    else
      @province_code=code.slice(0,2)+"0000000000"
      @region_code=code.slice(0,4)+"00000000"
      @city_code=code
      @region=$citytree[@province_code]
      @selected_city_name= $province_region[@province_code]+$province_region[@region_code]+$citytree[@province_code][@region_code][code]
    end    
    
  end
end
