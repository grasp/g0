#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

#require 'test_helper'
require  File.dirname(__FILE__) + "/../test_helper"
class W090IndexPageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "any user should see first page" do
    #open index
    b=$browser.goto "http://w090.com:5678/"
    assert (b)

    #check navi text and bottom text
    result=b.text.force_encoding('utf-8')
    ma=["关于物流零距离","货源信息","车源信息","联系我们"]
    ma.each do |text|
    assert result.include?(text)
    end
  end

  test "user open register form" do
    b=$browser.link(:href, "/users/new").click
    assert b
    result=$browser.text.force_encoding('utf-8')
    ma=["欢迎来到物流零距离","用户名","Email","密码"]
    ma.each do |text|
    assert result.include?(text)
    end
  end

    test "user click button without any fill" do
    b=$browser.button(:id, "user_submit").click
    assert b
    result=$browser.text.force_encoding('utf-8')
    ma=["用户名不能为空","email不能为空","密码不能为空","联系手机不能为空"]
    ma.each do |text|
    assert result.include?(text)
    end
  end

end

