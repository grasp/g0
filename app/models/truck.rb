# coding: utf-8
class Truck 
  include MongoMapper::Document
  
  #belongs_to :users
  #belongs_to :stock_trucks
  #has_many :inqueries
  #has_many :quotes
  
  #repeat stock_truck info for not go back search
      key  :paizhao,String
      key  :dunwei,String
      key  :length,String
      key  :shape,String
      key  :usage,String
      key  :driver_name,String
      key  :driver_phone,String
      key  :car_phone,String

      #truck info
      key  :send_date,String
      key  :status,String
      key  :comments,String
      key  :huicheng,String

      #line info
      key  :line,String
      key  :fcity_name,String
      key  :tcity_name,String
      key  :fcity_code,String
      key  :tcity_code,String
     
     # external search
      key  :company_id,ObjectId
      key  :user_id,ObjectId
      
      key :user_name,String 
      key :company_name,String
      
      key  :stock_truck_id,ObjectId
      key  :user_contact_id,ObjectId
       
      #for future usage
      key  :truck_pingjia_id,ObjectId
      key  :truck_status_id,ObjectId
      key  :tstatistic_id ,ObjectId      
      
      key :price,String
      key :price_unit,String


  # add more le
     key :from_site,String
  #statistic related
     key :total_baojia,Integer
     key :total_xunjia,Integer
     key :total_match,Integer
     key :total_click,Integer
   
   #chenjiao record
   
      key :cj_cargo_id,ObjectId
      key :cj_quote_id,ObjectId
      key :cj_user_id,ObjectId
      key :cj_company_id,ObjectId 
      validate :check_unique
      
     timestamps!

   def check_unique
    repeated=Truck.where(:paizhao=>self.paizhao,:line=>self.line,:user_id=>self.user_id,:status=>"正在配货")
    puts "repeated.size=#{repeated.size}"
    unless repeated.size==0
      errors.add_to_base("不能重复发布车源信息")
      return false
    end
    return true
  end
 
end
