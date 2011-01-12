class Search 
   include MongoMapper::Document
        cattr_reader :per_page
        @@per_page = 10
    key :fcity_code,String
    key :fcity_name,String
    key :tcity_code,String
    key :tcity_name,String
    key :stype,String
     timestamps!
    
end
