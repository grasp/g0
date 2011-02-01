 # coding: utf-8
module CargosHelper
    
 def get_max_min_code(code)
    max_code,min_code=0
   if code.match(/\d\d0000000000$/) # is a province id 
     puts "is province #{code}"
        max_code=(code.to_i+10000000000).to_s     
        puts "max_code=#{max_code}"
        min_code=code
   elsif code.match(/\d\d\d\d00000000$/)  and (not code.match(/\d\d0000000000$/))  # is a region
      puts "is region"
        max_code=(code.to_i+100000000).to_s
        min_code=code
   else
        puts "is city"
       max_code=code
       min_code=code
   end
   
   [min_code,max_code]
   
  end




end
