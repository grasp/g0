# coding: utf-8
class Inquery 
    include Mongoid::Document
    include Mongoid::Timestamps
  #belongs_to :trucks
  #belongs_to :cargos

    field :price,:type=>Integer
    field :comments,:type=>String

      #status
    field :status,:type=>String

   # foreign data
      field :cargo_id,:type=>String
      field :truck_id,:type=>String
      field :truck_company_id,:type=>String
      field :truck_user_id,:type=>String
      field :cargo_company_id,:type=>String
      field :cargo_user_id,:type=>String
      field :user_id,:type=>String
      
   #feature usage
      field :ismailed,:type=>Boolean
      field :isaccepted,:type=>Boolean
        index [[:cargo_id,Mongo::ASCENDING],[:truck_id,Mongo::ASCENDING]]
      #timestamps!
     #validate :check_unique
     
 # def check_unique
 #   repeated=Inquery.where(:cargo_id=>self.cargo_id,:truck_id=>self.truck_id)
 #      unless repeated.size==0
 #     errors.add_to_base("不能重复询价")
 #     return false
 #   end
 #   return true
 # end

end
