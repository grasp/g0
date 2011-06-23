#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
#if false
ENV["RAILS_ENV"] = "test"
#require  File.dirname(__FILE__) + "/../test_helper.rb"
start_time=Time.now
require 'watir'
require  'rubygems'
require 'active_support/all'
require 'test/unit/notify'
require "test/unit"
puts "load test env cost #{Time.now-start_time} sec"
#end


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all
  # Add more helper methods to be used by all tests here...
  #$browser = Watir::Browser.new()
  $browser =Watir::IE.new
  $browser.speed = :fast
  $browser.minimize
 #$browser.maximize
 
  $site_root= "http://localhost:5678"
  $user_name=Time.now.to_s.gsub(/\s|:|\+/,"").to_s
 
  $user_email="#{$user_name}@gmail.com"
  $mobile_phone=$user_name.slice(9,18)
   $paizhao=$mobile_phone.slice(0,6)
  $browser.goto("#{$site_root}")
  #each time run test, new a user
  
  puts "we got a new user =#{$user_name} with email=#{$user_email} and mobilephone=#{$mobile_phone}"
  #  $browser.goto("#{$site_root}")
 
  $browser.link(:href, "#{$site_root}/users/new").click
  $browser.text_field(:id, "user_name").set($user_name)
  $browser.text_field(:id, "user_email").set($user_email)
  $browser.text_field(:id, "user_password").set("1234567")
  $browser.text_field(:id, "user_password_confirmation").set("1234567")
  $browser.text_field(:id, "user_mobilephone").set($mobile_phone)
  $browser.button(:id, "user_submit").click
  #  result=$browser.text.force_encoding('utf-8')
  #  ["登出","我的货源","我的车源","关于物流零距离","完善公司信息","完善联系方式"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}
   
  #log out test
  sleep(2)  #need wait 1 sec after register

  $browser.link(:href, "#{$site_root}/users/logout").click
    
  def logout_and_login
    logout
    login
  end
  def logout
    result=$browser.text.force_encoding('utf-8')
    if result.include?("登出")
      $browser.link(:href, "#{$site_root}/users/logout").click;sleep 1
    else
      $browser.goto("#{$site_root}")
    end
  end
  def login
   assert $browser.link(:href, "#{$site_root}/users/login").click;sleep 1
    result=$browser.text.force_encoding('utf-8')
    ["欢迎来到物流零距离","用户登录","密码","用户名或Email"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}
    $browser.text_field(:id, "email").set($user_name)
    $browser.text_field(:id, "password").set("1234567")
    $browser.button(:value, "登录").click
  end

  def line_select(from_province,from_city,to_province,to_city)
     assert $browser.link(:id, "from_data_load").click;sleep 0.5
    ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
     assert $browser.link(:text, "#{from_province}").click;sleep 0.5
     ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
      assert $browser.link(:text, "#{from_city}").click;sleep 0.5
     ["#{from_province}","#{from_city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:id, "from_data_load").click;sleep 0.5
     ["#{from_province}","#{from_city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    
    assert $browser.link(:id, "to_data_load").click;sleep 0.5
    ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
     assert $browser.link(:text, "#{to_province}").click;sleep 0.5
     ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
      assert $browser.link(:text, "#{to_city}").click;sleep 0.5
     ["#{to_province}","#{to_city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:id, "to_data_load").click;sleep 0.5
     ["#{to_province}","#{to_city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
  end
  
end
require  File.dirname(__FILE__) + "/cargos/cargo_public_page_test"
require  File.dirname(__FILE__) + "/trucks/truck_page_test"
require  File.dirname(__FILE__) + "/trucks/new_stock_truck_and_truck"
require  File.dirname(__FILE__) + "/users/user_page_test"
require  File.dirname(__FILE__) + "/cargos/new_stock_cargo"
require  File.dirname(__FILE__) + "/companies/new_company"
require  File.dirname(__FILE__) + "/contacts/new_contact"

