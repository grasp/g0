 # coding: utf-8
class Company 
   include Mongoid::Document
   include Mongoid::Timestamps
 
 # has_many :users
 
     field :name, :type=>String
     field :about, :type=>String
     field :self_che, :type=>Integer
     field :signed_che, :type=>Integer
     field :num_employ, :type=>Integer
     field :contact_name, :type=>String
     field :city_name, :type=>String
     field :city_code, :type=>String
     field :city_id, :type=>String
     field :address, :type=>String 
     field :quhao, :type=>String
     field :fix_phone, :type=>String
     field :mobile_phone, :type=>String
     field :email, :type=>String    
     field :user_name, :type=>String
     field :ispersonal, :type=>Integer
    # embeds_one :company_licenses
    # referenced_in :user
    field :user_id
      
    validates_uniqueness_of :name ,:message=>"该公司名字已经被注册."
    validates_uniqueness_of :email ,:message=>"该Email所属公司已经被注册."
end
