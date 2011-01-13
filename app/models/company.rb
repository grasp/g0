class Company 
 include MongoMapper::Document
  attr_accessor :quhao
 # has_many :users
 
      key :name,String
      key :about,String
      key :self_che,Integer
      key :signed_che,Integer
      key :num_employ,Integer
      key :contact_name,String
      key :city_name,String
      key :city_code,String
      key :city_id,String
      key :address,String     
      key :fix_phone,String
      key :mobile_phone,String
      key :email,String
      key :company_license_id,ObjectId
      key :user_name,String
       key :ispersonal,Integer
      key :user_id,ObjectId
      timestamps!
end
