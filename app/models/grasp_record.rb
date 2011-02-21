# To change this template, choose Tools | Templates
# and open the template in the editor.

class GraspRecord
    include MongoMapper::Document
      key :diff_che,Integer
      key :diff_huo,Integer
      key :cycle_che,Integer
      key :cycle_huo,Integer
      key :total_che,Integer
      key :total_huo,Integer      
      key :cost_time,String 
      key :fail_counter,Integer
      key :succ_counter,Integer
      
      key :miss_field_huo,Integer
      key :miss_field_che,Integer      
      key :repeat_huo,Integer
      key :repeat_che,Integer
      key :cargos_lines,Array
      key :trucks_lines,Array
      timestamps!    
end

