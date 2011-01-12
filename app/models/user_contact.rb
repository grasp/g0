class UserContact 
include MongoMapper::Document
  # belongs_to :users
  
      key :name,String
      key :email,String
      key :mobile_phone,String
      key :phone_quhao,String
      key :fix_phone,String
      key :QQ,String
      key :website,String
      key :city_name,String
      key :city_code,String
      key :address,String
      key :company_id,ObjectId
      key :user_id,ObjectId
      timestamps!
 
end
