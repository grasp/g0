#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
if false
  ENV["RAILS_ENV"] = "test"
  start_time=Time.now
  require 'watir'
  require  'rubygems'
  require 'active_support/all'
  require "test/unit"
  puts "load test env cost #{Time.now-start_time} sec"
end


class W090UserPageTest < ActiveSupport::TestCase
  
test "user_register_login_logout" do 
  #"0-any_user_should_see_first_page"
    puts "0any user should see first page"
    #open index
    b=$browser.goto "#{$site_root}"
    assert (b)
    #check navi text and bottom text
    result=$browser.text.force_encoding('utf-8')
    ma=["关于物流零距离","货源信息","车源信息","联系我们"]
    ma.each do |text|
      assert result.include?(text),"#{text} 不存在 !!"
    end


  #"1-user open register form" 
    puts "1-user open register form"
    b=$browser.link(:href, "#{$site_root}/users/new").click
    assert b
    result=$browser.text.force_encoding('utf-8')
    ma=["欢迎来到物流零距离","用户名","Email","密码"]
    ma.each do |text|
      assert result.include?(text),"#{text} 不存在 !!"
    end

  #"2-user click button without any fill"
    puts "2user click button without any fill"
    $browser.link(:href, "#{$site_root}/users/new").click
    b=$browser.button(:id, "user_submit").click
    assert b
    result=$browser.text.force_encoding('utf-8')
    ma=["用户名不能为空","email不能为空","密码不能为空","联系手机不能为空"]
    ma.each do |text|
      assert result.include?(text),"#{text} 不存在 !!"
    end


#"3-user name should unique when create" 
    puts "3user name should unique when create"
    #admin create should fail
    sleep 1
    $browser.link(:href, "#{$site_root}/users/new").click
    $browser.text_field(:id, "user_name").set("admin")
    $browser.text_field(:id, "user_email").set("admin@gmail.com")
    $browser.text_field(:id, "user_password").set("admin111")
    $browser.text_field(:id, "user_password_confirmation").set("admin111")
    $browser.text_field(:id, "user_mobilephone").set("13788901123")
    b=$browser.button(:id, "user_submit").click
    assert b
    result=$browser.text.force_encoding('utf-8')
    ma=["该用户名已经存在"]
    ma.each do |text|
      assert result.include?(text),"#{text} 不存在 !!"
    end

#user register and login" 
         puts "00000-user register and login"
     $browser.goto("#{$site_root}")
 
    $browser.link(:href, "#{$site_root}/users/new").click
    $browser.text_field(:id, "user_name").set($user_name)
    $browser.text_field(:id, "user_email").set($user_email)
    $browser.text_field(:id, "user_password").set("1234567")
    $browser.text_field(:id, "user_password_confirmation").set("1234567")
    $browser.text_field(:id, "user_mobilephone").set($mobile_phone)
    $browser.button(:id, "user_submit").click
    result=$browser.text.force_encoding('utf-8')
    ["登出","我的货源","我的车源","关于物流零距离","完善公司信息","完善联系方式"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}
   
    #log out test
    sleep(2)  #need wait 1 sec after register

    $browser.link(:href, "#{$site_root}/users/logout").click
    result=$browser.text.force_encoding('utf-8')
    ["登录","货源信息","快速注册,永久免费","车源信息","关于物流零距离"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}
    #login test
    sleep(2)
    $browser.link(:href, "#{$site_root}/users/login").click
    result=$browser.text.force_encoding('utf-8')
    ["欢迎来到物流零距离","用户登录","密码","用户名或Email"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}
    $browser.text_field(:id, "email").set($user_name)
    $browser.text_field(:id, "password").set("1234567")
    $browser.button(:value, "登录").click
    sleep 1
    result=$browser.text.force_encoding('utf-8')
    ["登出","我的货源","我的车源","关于物流零距离"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}
    sleep(2) #need wait enough time here
    $browser.link(:href, "#{$site_root}/users/logout").click
    sleep(1)
 

 #"5repeated username register" 
    puts " 5repeated username register"
    
   result=$browser.text.force_encoding('utf-8')
    if result.include?("登出")
      $browser.link(:href, "#{$site_root}/users/logout").click
    end
    
    sleep 2
    $browser.link(:href, "#{$site_root}/users/new").click
    $browser.text_field(:id, "user_name").set($user_name)
    $browser.text_field(:id, "user_email").set("#{$user_name+"1"}@gmail.com")
    $browser.text_field(:id, "user_password").set("1234567")
    $browser.text_field(:id, "user_password_confirmation").set("1234567")
    $browser.text_field(:id, "user_mobilephone").set($mobile_phone.chop+"1")
    $browser.button(:id, "user_submit").click
    result=$browser.text.force_encoding('utf-8')
    ["该用户名已经存在"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}

  
 # "6repeated email regester" 
    puts "6 repeated email regester"
    $browser.link(:href, "#{$site_root}/users/new").click
    $browser.text_field(:id, "user_name").set($user_name.chop+"1")
    $browser.text_field(:id, "user_email").set("#{$user_name}@gmail.com")
    $browser.text_field(:id, "user_password").set("1234567")
    $browser.text_field(:id, "user_password_confirmation").set("1234567")
    $browser.text_field(:id, "user_mobilephone").set($mobile_phone.chop+"2")
    $browser.button(:id, "user_submit").click
    result=$browser.text.force_encoding('utf-8')
    ["该email已经存在"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}


 # "7repeated mobile phone register" 
    puts "7 repeated mobile phone register"
    $browser.link(:href,"#{$site_root}/users/new").click
    $browser.text_field(:id, "user_name").set($user_name.chop+"2")
    $browser.text_field(:id, "user_email").set("#{$user_name.chop+"2"}@gmail.com")
    $browser.text_field(:id, "user_password").set("1234567")
    $browser.text_field(:id, "user_password_confirmation").set("1234567")
    $browser.text_field(:id, "user_mobilephone").set($mobile_phone)
    $browser.button(:id, "user_submit").click
    result=$browser.text.force_encoding('utf-8')
    ["该手机已经存在"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}


 #"8-login as email account" 
    $browser.link(:href, "#{$site_root}/users/login").click
    $browser.text_field(:id, "email").set($user_email)
    $browser.text_field(:id, "password").set("1234567")
    $browser.button(:value, "登录").click
    result=$browser.text.force_encoding('utf-8')
    ["登出","我的货源","我的车源","关于物流零距离"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}

end
end
