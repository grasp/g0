class Cstatistic
      include MongoMapper::Document
  #belongs_to :cargos
      key :total_baojia,Integer
      key :total_xunjia,Integer
      key:total_match,Integer
      key :total_click,Integer
      key :user_id,ObjectId
      key :cargo_id,ObjectId
      timestamps!
end
