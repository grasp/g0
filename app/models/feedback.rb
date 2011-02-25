# coding: utf-8
class Feedback 
  include MongoMapper::Document
  
 
      key  :pingjia,String
      key  :satisfy,String
      key  :hate,String
      key  :improve,String
      #for statistic
      key  :user_id
      key  :user_name
      key  :ip
      
     timestamps!
 
end
