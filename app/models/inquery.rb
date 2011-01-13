class Inquery 
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

end
