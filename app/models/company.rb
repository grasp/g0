 # coding: utf-8
class Company 
 include MongoMapper::Document
 
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
      key :quhao, String
      key :fix_phone,String
      key :mobile_phone,String
      key :email,String
      key :company_license_id,ObjectId
      key :user_name,String
      key :ispersonal,Integer
      key :user_id,ObjectId
      
    validates_uniqueness_of :name ,:message=>"该公司已经被注册."
    validates_uniqueness_of :email ,:message=>"该公司已经被注册."
    timestamps!
end
