class Tstatistic
    include MongoMapper::Document
     key :total_baojia,Integer
     key :total_xunjia,Integer
     key :total_match,Integer
     key :total_click,Integer
     key :user_id,ObjectId
     key :truck_id,ObjectId      
    timestamps!
end
