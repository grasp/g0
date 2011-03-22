#coding:utf-8
class UserMailer < ActionMailer::Base
  default :from => "hunter.wxhu@gmail.com"
  
    def welcome_email(user,url)
    @user = user
  #  @url  = "http://example.com/login"
    mail(:to => user.email,
         :subject => "欢迎来到物流零距离",
         :body =>url)
    end

end
