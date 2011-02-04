 # coding: utf-8
module CargosHelper
    
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
   puts "code=#{code},min_code=#{min_code},max_code=#{max_code},iscity=#{iscity}"
   [min_code,max_code,iscity]
   
  end




end
