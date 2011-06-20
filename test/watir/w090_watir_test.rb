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
  $browser = Watir::Browser.new()
  $browser.minimize
  $site_root= "http://localhost:5678"
  $user_name=Time.now.to_s.gsub(/\s|:|\+/,"").to_s
  $user_email="#{$user_name}@gmail.com"
  $mobile_phone=$user_name.slice(9,18)
  $browser.goto("#{$site_root}")
  #each time run test, new a user
  
  puts "we got a new user =#{$user_name} with email=#{$user_email} and mobilephone=#{$mobile_phone}"

  
end
require  File.dirname(__FILE__) + "/cargos/cargo_page_test"
require  File.dirname(__FILE__) + "/users/user_page_test"

