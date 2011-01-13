class LineAd
   include MongoMapper::Document
      key :line,String
      key :fcity_name,String
      key :tcity_name,String
      key :company_name,String
      key :url,String
      key :one_word,String
      key :contact_phone,String
      key :user_id,ObjectId
      key :company_id,ObjectId
      key :lstatistic_id,String
      timestamps!
end
