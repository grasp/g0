# coding: utf-8
class Truck 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  #belongs_to :users
  #belongs_to :stock_trucks
  #has_many :inqueries
  #has_many :quotes
  
  #repeat stock_truck info for not go back search
      field  :paizhao,:type=>String
      field  :dunwei,:type=>String
      field  :length,:type=>String
      field  :shape,:type=>String
      field  :usage,:type=>String
      field  :driver_name,:type=>String
      field  :driver_phone,:type=>String
      field  :car_phone,:type=>String

      #truck info
      field  :send_date,:type=>String
      field  :status,:type=>String
      field  :comments,:type=>String
      field  :huicheng,:type=>String

      #line info
      field  :line,:type=>String
      field  :fcity_name,:type=>String
      field  :tcity_name,:type=>String
      field  :fcity_code,:type=>String
      field  :tcity_code,:type=>String    

      
      field :user_name,:type=>String 
      field :company_name,:type=>String     

       
      #for future usage
      field  :truck_pingjia_id
      field  :truck_status_id
      field  :tstatistic_id 
      
      field :price,:type=>String
      field :price_unit,:type=>String

     # add more le
     field :from_site,:type=>String
    #statistic related
     field :total_baojia,:type=>Integer
     field :total_xunjia,:type=>Integer
     field :total_match,:type=>Integer
     field :total_click,:type=>Integer
   
      #chenjiao record   
      field :cj_cargo_id
      field :cj_quote_id
      field :cj_user_id
      field :cj_company_id
      
      # external search
      field  :company_id
      field  :user_id
      field  :stock_truck_id
      field  :user_contact_id
      index ([[:updated_at,Mongo::ASCENDING],[:status,Mongo::ASCENDING],[:fcity_code,Mongo::ASCENDING],[:tcity_code,Mongo::ASCENDING]])
  
     validate :check_unique,:on=>:create
      
    def check_unique

   if self.from_site!="quzhou"
    repeated=Truck.where(:paizhao=>self.paizhao,:line=>self.line,:user_id=>self.user_id,:status=>"正在配货",
            :comments=>self.comments,:from_site=>self.from_site)
   else
        repeated=Truck.where(:line=>self.line,:user_id=>self.user_id,:status=>"正在配货",
            :comments=>self.comments,:from_site=>self.from_site)
   end
   # puts "repeated.size=#{repeated.size}"
    unless repeated.size==0
       errors.add(:base,"不能重复发布车源信息")
      return false
    end
    return true
     end
 
end
