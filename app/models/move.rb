# To change this template, choose Tools | Templates
# and open the template in the editor.
class Move 
    include MongoMapper::Document
      key :expired_cargo,Integer
      key :expired_truck,Integer
      key :expired_quote,Integer
      key :expired_inquery,Integer
      key :cost_time,String
      key :user_id,ObjectId
      timestamps!
end
