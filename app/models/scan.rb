class Scan 
    cattr_reader :per_page
     @@per_page = 20
    include MongoMapper::Document
      key :total_user,Integer
      key :total_stock_truck,Integer
      key :total_stock_cargo,Integer
      key :idle_stock_truck,Integer
      key :idle_stock_cargo,Integer
      key :total_cargo,Integer
      key :total_truck,Integer
      key :valid_cargo,Integer
      key :valid_truck,Integer
      key :expired_cargo,Integer
      key :expired_truck,Integer
      key :chenjiao_truck,Integer
      key :chenjiao_cargo,Integer
      key :total_line,Integer
      key :total_company,Integer
      key :cost_time,String
      key :user_id,ObjectId
       timestamps!
end
