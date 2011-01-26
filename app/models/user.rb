 # coding: utf-8
class User 
  include MongoMapper::Document
 # include UsersHelper
  
  attr_accessor:password_confirmation,:email_confirm
  
  key :email,String
  key :name,String
  key :admin,Boolean, :default=>false
  key :real_name,String
  key :hashed_password,String
  key :salt,String
  key :status,String
  key :activate,String
  key :company_id,ObjectId
  key :user_contact_id,ObjectId
  key :ustatistic_id,ObjectId
  key :preference,Integer
  
  validates_presence_of :email,:name,:message=>"用户名和email必须填写."
  validates_uniqueness_of :name ,:message=>"该用户名已经存在."
  validates_uniqueness_of :email ,:message=>"该email已经存在."
  timestamps!
  
 
  
   def self.authenticated_with_token(user_id, stored_salt)
     u = find_by_id(user_id)
     u && u.salt == stored_salt ? u : nil
   end
  
  def self.authenticate(email_or_name,password)

    if(email_or_name.match(/.*@.*\..*/))
     user=self.find_by_email(email_or_name.to_s)
    else
      user=self.find_by_name(email_or_name.to_s)
    end
    puts "self.count=#{User.count}"
    puts "email_or_name=#{email_or_name}"
    puts "password=#{password}"
    if user
      expected_password=encrypted_password(password,user.salt)
      if user.hashed_password!=expected_password
        user= nil
        message="密码不对"
      end

    else
    message="#{email_or_name}用户不存在"
    user=nil
    end
    
    [user,message]
  end

  def password
    @password
  end  
  

  #here will generate password ,each result is different even have same password
  def password=(pwd)
    @password=pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password=User.encrypted_password(self.password, self.salt)
  end

 #private

  def password_non_blank
    errors.add_to_base("Missing password")  if :hashed_password.blank?
  end

 def self.encrypted_password(password,salt)
    string_to_hash=password+ "wibble" +salt
    Digest::SHA1.hexdigest(string_to_hash)
  end


  def create_new_salt
    self.salt= self.object_id.to_s+rand.to_s
  end
  

end
