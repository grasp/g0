# To change this template, choose Tools | Templates
# and open the template in the editor.

class HourData 
    include Mongoid::Document
    include Mongoid::Timestamps
      field :datehour,:type=>String
      field :user_new,:type=>Integer
      field :total_user,:type=>Integer
      field :contact_new,:type=>Integer
      field :total_contact,:type=>Integer
      field :company_new,:type=>Integer
      field :total_company,:type=>Integer
      field :cargo_new,:type=>Integer
      field :total_cargo,:type=>Integer
      field :truck_new,:type=>Integer
       field :quote_new,:type=>Integer
       field :inquery_new,:type=>Integer
      field :total_truck,:type=>Integer
      field :total_quote,:type=>Integer
      field :total_inquery,:type=>Integer
      field :user_id
     # timestamps!
end

