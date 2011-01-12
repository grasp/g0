class Ustatistic
    include MongoMapper::Document
      key :total_stock_cargo,Integer
      key :total_stock_truck,Integer
      key :total_cargo,Integer
      key :total_truck,Integer
      key :total_line,Integer
      key :total_driver,Integer
      key :total_custermer,Integer
      key :user_id,ObjectId
      timestamps!

end
