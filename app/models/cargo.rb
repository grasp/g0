class Cargo 
    include MongoMapper::Document
     cattr_reader :per_page
     @@per_page = 3
    # belongs_to :users
   #  has_many :quotes
    # has_many :inqueries
   #  has_one :cstatistic 
   
   # cargo self info
      key :cargo_weight,String
      key :cargo_zuhuo,String
      key :cargo_bulk,String
      key :send_date,String
      key :comments,String
      key :status,String

      #for not go back to find stock_cargo
      key :cate_name,String
      key :package_name,String
      key :big_category,String

      # important line info
      key :line,String
      key :fcity_name,String
      key :tcity_name,String
      key :fcity_code,String
      key :tcity_code,String
      
      # for contact
      key :user_id,ObjectId
      key :company_id,ObjectId
      key :stock_cargo_id,ObjectId
      key :user_contact_id,ObjectId

      #important information
      key :zhuang_addr,String
      key :zhuang_time,String
      key :xie_addr,String

      #future usage
      key :pingjia_id,ObjectId
      key :cstatistic_id,ObjectId
      
     timestamps!

     
end
