#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class W090CargoPageTest < ActiveSupport::TestCase

  test "public user select cargo " do
    puts "00-user can open public cargo list-W090CargoPageTest"
    $browser.goto("#$site_root")
    assert $browser.link(:id, "huo_info").click;    sleep 1
    result=$browser.text.force_encoding('utf-8')
    ["货物","出发地","到达地","有效期"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"}   

    puts "01-click  line select-W090CargoPageTest"
    assert $browser.link(:id, "from_data_load").click;    sleep 1
    result=$browser.text.force_encoding('utf-8')
    ["出发城市","北京","吉林","黑龙江","重庆市","上海"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
    
    #click to 浙江
    assert $browser.link(:text, "浙江").click;     sleep 1
    result=$browser.text.force_encoding('utf-8')
   ["出发城市","北京","吉林","黑龙江","重庆市","上海"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
    assert $browser.link(:id, "from_data_load").click  #to close from select
    
   assert $browser.link(:id, "to_data_load").click; sleep 1
     result=$browser.text.force_encoding('utf-8')
   ["到达城市","北京","吉林","黑龙江","重庆市","上海"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
    assert $browser.link(:id, "to_data_load").click   sleep 1
 
    
      #click to 浙江
    assert $browser.link(:text, "浙江").click; sleep 1   
    result=$browser.text.force_encoding('utf-8')
   ["到达城市","北京","吉林","黑龙江","重庆市","上海"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
    assert $browser.link(:id, "to_data_load").click  #to close from select
    #
    #click search
    assert $browser.link(:id, "search").click;  sleep 1  
     
  end
  
end
