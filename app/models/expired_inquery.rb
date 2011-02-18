# coding: utf-8
class ExpiredInquery 
    include MongoMapper::Document
  #belongs_to :trucks
  #belongs_to :cargos

      key :price,Integer
      key :comments,String

      #status
      key :status,String

   # foreign data
      key:cargo_id,ObjectId
      key:truck_id,ObjectId
      key:truck_company_id,ObjectId
      key:truck_user_id,ObjectId
      key:cargo_company_id,ObjectId
      key:cargo_user_id,ObjectId
      key:user_id,ObjectId
      
   #feature usage
      key:ismailed,Boolean
      key:isaccepted,Boolean
      timestamps!
     validate :check_unique
  def check_unique
    repeated=Inquery.where(:cargo_id=>self.cargo_id,:truck_id=>self.truck_id)
       unless repeated.size==0
      errors.add_to_base("不能重复询价")
      return false
    end
    return true
  end

end
