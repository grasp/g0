class StockCargo
  #  belongs_to :users
   include MongoMapper::Document
    #category related
      key :big_category,String
      key :cate_name,String
      key :cate_code,String

      #packakge related
      key :package_name,String
      key :package_code,String

      #cargo property and status
      key :cargo_property,String

      #expired/invalid/normal
      key :stock_status,String
      
      #weight and buld
      key :ku_weight,String
      key :ku_bulk,String
     
      
      key :sent_weight,String
      key :sent_bulk,String
      
     #define for search
      key :cangku_id,ObjectId
      key :user_id,ObjectId
      key  :company_id ,ObjectId 
      key  :scstatistic_id,ObjectId

      #status
      key :status,String

      timestamps!
end
