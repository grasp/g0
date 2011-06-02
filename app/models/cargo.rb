# coding: utf-8
class  Cargo
   include Mongoid::Document
   include Mongoid::Timestamps
    # cattr_reader :per_page
    # @@per_page = 20      
   # cargo self info
      field :cargo_weight, :type=>String
      field :cargo_zuhuo, :type=>String
      field :cargo_bulk, :type=>String
      field :send_date, :type=>String
      field :comments, :type=>String
      field :status, :type=>String

      #for not go back to find stock_cargo
      field :cate_name, :type=>String
      field :package_name, :type=>String
      field :big_category, :type=>String

      # important line info
      field :line, :type=>String
      field :fcity_name, :type=>String
      field :tcity_name, :type=>String
      field :fcity_code, :type=>String
      field :tcity_code, :type=>String   

      #important information
      field :zhuang_addr, :type=>String
      field :zhuang_time, :type=>String
      field :xie_addr, :type=>String
      
      field :price, :type=>String
      field :price_unit, :type=>String
      
  # from site
      field :from_site, :type=>String
     
    # statistic
      field :total_baojia, :type=>Integer
      field :total_xunjia, :type=>Integer
      field :total_match, :type=>Integer
      field :total_click, :type=>Integer
      
      field :cj_truck_id
      field :cj_quote_id
      field :cj_user_id
      field :cj_company_id
      
    #future usage
      field :user_id
      field :user_contact_id
      field :company_id
     field :stock_cargo_id

      
     index ([[:updated_at,Mongo::ASCENDING],[:status,Mongo::ASCENDING],[:fcity_code,Mongo::ASCENDING],[:tcity_code,Mongo::ASCENDING]])
    validates_presence_of :cate_name,:fcity_code,:tcity_code     
    validate :check_unique,:on=>:create
  def check_unique
    repeated=Cargo.where(:cate_name=>self.cate_name,:line=>self.line,:user_id=>self.user_id,:status=>"正在配车",:comments=>self.comments)
       unless repeated.size==0
      errors.add(:base,"不能重复发布货源信息")
     return false
    end
    return true
  end
     
end
