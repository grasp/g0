class MailAccount
  include Mongoid::Document
  field :address, :type => String
  field :port, :type => String
  field :username, :type => String
  field :password, :type => String
  field :authentication, :type => String
  field :enable_startttls, :type => Boolean
  field :today_sent, :type => Integer
  field :total_sent, :type => Integer
  field :last_use, :type => Time
  field :rejected, :type => String
  field :status, :type => String
end
