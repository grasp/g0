class UserContact 
include MongoMapper::Document
  # belongs_to :users
  
      key :name,String
      key :email,String
      key :mphone,String
      key :quhao,String
      key :fixphone,String
      key :QQ,String
      key :website,String
      key :city_name,String
      key :city_code,String
      key :address,String
      key :company_id,ObjectId
      key :user_id,ObjectId
      timestamps!
 
end
