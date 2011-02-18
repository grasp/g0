# coding: utf-8
class ExpiredQuote 
  # belongs_to :cargos
  # belongs_to :trucks
   include MongoMapper::Document
     #basic infor
      key :price,Integer
      key :comments,String
      key :cargo_id,ObjectId
      key :truck_id,ObjectId
      key :truck_user_id,ObjectId
      key :truck_company_id,ObjectId
      key :cargo_user_id,ObjectId
      key :cargo_company_id,ObjectId
      key :user_id,ObjectId

      #status of quotes
      key:status,String


      # for future usage
      key :ismailed,Boolean
      key :isaccepted,Boolean
      

      timestamps!
      
     validate :check_unique
  def check_unique
    repeated=Quote.where(:cargo_id=>self.cargo_id,:truck_id=>self.truck_id)
       unless repeated.size==0
      errors.add_to_base("不能重复报价")
      return false
    end
    return true
  end

end
