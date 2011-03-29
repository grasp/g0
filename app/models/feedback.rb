# coding: utf-8
class Feedback 
include Mongoid::Document
include Mongoid::Timestamps
  
 
     field :pingjia,:type=>String
     field :satisfy,:type=>String
     field :hate,:type=>String
     field :improve,:type=>String
      #for statistic

     field :user_name,:type=>String
     field :ip,:type=>String
     embeds_one :users      
     #timestamps!
 
end
