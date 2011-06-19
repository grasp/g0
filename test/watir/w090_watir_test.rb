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

require  File.dirname(__FILE__) + "/users/user_page_test"

