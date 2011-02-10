# coding: utf-8
class StockTruck 
   include MongoMapper::Document
  #  belongs_to :users
   # has_many :trucks
    #stock truck basic info
      key :paizhao,String
      key :dun_wei,String
      key :che_length,String
      key :truck_usage,String
      key :truck_shape,String
      key :truck_gps,String

      #Manufacture info
      key :truck_pinpai,String
      key :truck_xinghao,String
      key :truck_year,String


      #driver info
      key :driver_name,String
      key :driver_phone,String
      
      #owner info
      key :owner_name,String
      key :owner_phone,String
      
      #owner info
      key :bis_name,String
      key :bis_phone,String

      # contact inforamtion
      key :company_id,ObjectId
      key :car_phone,String
      key :user_id,ObjectId
      
      #Statistic
      key :valid_truck,Integer
      key :expired_truck,Integer

      #status
      key :status,String

      # for feature usage
      key :truck_license_id,ObjectId
      key :truck_owner_id,ObjectId
      
      validates_uniqueness_of :paizhao ,:message=>"该牌照车子已经存在."

      timestamps!
end
