# To change this template, choose Tools | Templates
# and open the template in the editor.

class Quzhougrasp 
    include MongoMapper::Document
      key :diff_che,Integer
      key :diff_huo,Integer
      key :cycle_che,Integer
      key :cycle_huo,Integer
      key :total_che,Integer
      key :total_huo,Integer      
        key :cost_time,String 
      timestamps!    
end

