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
  field :last_use, :type => String
  field :rejected, :type => String
  field :status, :type => String

  field :day_max,:type=>Integer
  field :receiver_max,:type=>Integer
  field :send_interval,:type=>Integer
  field :fail_counter,:type=>Integer
end
