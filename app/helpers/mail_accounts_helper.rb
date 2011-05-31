module MailAccountsHelper

  class UserMailer < ActionMailer::Base
     def test_email(account)
      mail(:to => "mark.xiansheng@gmail.com",
          :from => "#{account}@w090.com",
          :subject => "#{account} test",
          :body=>"This is test mail account work!")
   end
end
ActionMailer::Base.delivery_method = :smtp
  def batch_insert_gmail_account
    gmail_account=[]
    16.downto(1).each {|i|  gmail_account<<"w090."+ "%03d" % i}
    gmail_account.delete("w090.006")
    #gmail_account.delete("w090.001")
    first_account=MailAccount.where(:username=>"w090.001").first
    if first_account.blank? #insert mail account for first time
     gmail_account.each do |account|
       new_account=Hash.new
       new_account[:address]="smtp.gmail.com"
       new_account[:username]=account
       new_account[:password]="11102008"
       new_account[:port]="587"
       new_account[:authentication]="plain"
       new_account[:enable_startttls]="true"
       a=MailAccount.new(new_account)
       raise unless a.save
     end
      end
     Rails.logger.info "params[:test_mail]=#{params[:test_mail]}"
      #test mail_account work
      if params[:test_mail]=="test"
   
        MailAccount.all.each do |mail_account|
        ActionMailer::Base.smtp_settings = {
       :enable_starttls_auto => mail_account.enable_startttls,
       :address => mail_account.address,
       :port => mail_account.port,
      :authentication => mail_account.authentication,
       :user_name => mail_account.username,
      :password => mail_account.password
  }
  UserMailer.test_email(mail_account.username).deliver!
 Rails.logger.info "sent out email #{mail_account.username}"
        end
      end

    end

end
