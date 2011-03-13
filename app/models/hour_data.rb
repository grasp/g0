# To change this template, choose Tools | Templates
# and open the template in the editor.

class HourData 
    include MongoMapper::Document
      key :datehour,String
      key :user_new,Integer
      key :total_user,Integer
      key :contact_new,Integer
      key :total_contact,Integer
      key :company_new,Integer
      key :total_company,Integer
      key :cargo_new,Integer
      key :total_cargo,Integer
      key :truck_new,Integer
      key :total_truck,Integer
      key :total_quote,Integer
      key :total_inquery,Integer
      key :user_id,ObjectId      
      timestamps!
end

