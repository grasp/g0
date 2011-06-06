#coding:utf-8
module MailAccountsHelper
  class UserMailer < ActionMailer::Base
    def test_email(account)
      mail(:to => "mark.xiansheng@gmail.com",
        :from => "#{account}@w090.com",
        :subject => "#{account} test",
        :body=>"This is test mail account work!")
    end
    def tuiguang_email(from,to,company_name)
      @company_name=company_name
      mail(:to => to,
        :from => from,
        :subject => "物流零距离网站-邀请您的第一次访问" )  do |format|
        format.html { render '/admin/tuiguang' }
      end
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
        new_account[:fullname]=account+"@gmail.com"
        new_account[:password]="11102008"
        new_account[:port]="587"
        new_account[:day_max]="49"
        new_account[:send_interval]="15"
        new_account[:authentication]="plain"
        new_account[:enable_startttls]="true"
        a=MailAccount.new(new_account)
        raise unless a.save
      end
    end
  end
 def batch_insert_netease_account
    netease_account=[]
    15.downto(1).each {|i|  netease_account<<"w090_"+ "%03d" % i}
    #have a mistake for w011
    netease_account.delete("w090_011")
      netease_account<<"w90_011"
    first_account=MailAccount.where(:fullname=>"w090_001@163.com").first
    if first_account.blank? #insert mail account for first time
      netease_account.each do |account|
        new_account=Hash.new
        new_account[:address]="smtp.163.com"
        new_account[:username]=account
        new_account[:fullname]=account+"@163.com"
        new_account[:password]="followme123#"
        new_account[:port]="25"
        new_account[:day_max]="49"
        new_account[:send_interval]="25"
        new_account[:authentication]=":login"
        new_account[:enable_startttls]="true"
        a=MailAccount.new(new_account)
        raise unless a.save
      end
    end
  end
 def batch_insert_hotmail_account
    hotmail_account=[]
    8.downto(1).each {|i|  hotmail_account<<"w090_"+ "%03d" % i}
    #have a mistake for w011
  #  hotmail_account.delete("w090_011")
   #   hotmail_account<<"w90_011"
    first_account=MailAccount.where(:fullname=>"w090_001@hotmail.com").first
    if first_account.blank? #insert mail account for first time
      hotmail_account.each do |account|
        new_account=Hash.new
        new_account[:address]="smtp.live.com"
        new_account[:username]=account
        new_account[:fullname]=account+"@hotmail.com"
        new_account[:password]="followme123#"
        new_account[:port]="25"
        new_account[:day_max]="49"
        new_account[:send_interval]="15"
        new_account[:authentication]=":login"
        new_account[:enable_startttls]="true"
        a=MailAccount.new(new_account)
        raise unless a.save
      end
    end
  end

  def sent_tuiguang_email(mode,domain)
    #for each mail account , sent out limited mail
     Rails.logger.info "mode=#{mode},domain=#{domain}"

    MailAccount.where(:address=>domain).each do |mail_account|
      if domain=="smtp.gmail.com"
      ActionMailer::Base.smtp_settings = {
        :enable_starttls_auto => mail_account.enable_startttls,
        :address => mail_account.address,
        :port => mail_account.port,
        :authentication => mail_account.authentication ,
        :user_name => mail_account.username,
        :password => mail_account.password
      }
      end
     if domain=="smtp.163.com"
      ActionMailer::Base.smtp_settings = {
         :address => mail_account.address,
        :port => mail_account.port,
        :domain   => "163.com",
        :authentication => :login ,
        :user_name => mail_account.fullname,
        :password => mail_account.password
      }
      end
       if domain=="smtp.live.com"
      ActionMailer::Base.smtp_settings = {
         :address => mail_account.address,
        :port => mail_account.port,
    #    :domain   => "hotmail.com",
        :authentication => :login ,
        :user_name => mail_account.fullname,
        :password => mail_account.password
      }
      end
      #find #{mail_account[:day_max]} lib_company and send out email for each company
      mail_account[:day_max]=1  if mode=="test"

      LibCompany.where(:sent_counter=>nil).limit(mail_account[:day_max]).each do |company|
        #for debug purpose
        company.email="mark.xiansheng@gmail.com"   if mode=="test"  && domain=="smtp.gmail.com"
        company.email="w090_001@163.com"   if mode=="test" && domain=="smtp.163.com"
        company.email="w090_001@hotmail.com"   if mode=="test" && domain=="smtp.live.com"
       Rails.logger.info " to #{company.email} from #{mail_account.fullname}"
        begin
          UserMailer.tuiguang_email(mail_account.fullname,company.email,company.name).deliver!
          company.update_attributes(:sent_counter=>1,:last_sent_time=>Time.now,:status=>"enabled")
          mail_account.inc(:today_sent,1)
          mail_account.inc(:total_sent,1)

          sleep(mail_account[:send_interval])  #for gmail sleep 10 second
        rescue
          Rails.logger.info " sent to #{company.email} failed"
          @exception=$@
          mail_account.inc(:fail_counter,1)
          raise
        end

      end
    end

  end
end
