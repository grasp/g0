class Lstatistic
  include MongoMapper::Document
      key :line,String
      key :valid_cargo,Integer
      key :valid_truck,Integer
      key :total_cargo,Integer
      key :total_truck,Integer
      timestamps!  
end
