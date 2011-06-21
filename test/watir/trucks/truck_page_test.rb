#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class TruckCargoPageTest < ActiveSupport::TestCase

  test "public user search truck " do
    puts "public user search truck"
    $browser.goto("#$site_root")
    assert $browser.link(:id, "che_info").click;    sleep 1
    result=$browser.text.force_encoding('utf-8')
    ["车辆","出发地","到达地","有效期"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"}  
    
   #click page 2
   7.downto(2).each do |i|
   assert $browser.link(:href, "#{$site_root}/trucks/search/100000000000/100000000000/#{i}?fcity_code=100000000000&tcity_code=100000000000").click;  sleep 1  
   result=$browser.text.force_encoding('utf-8')
   ["关于物流零距离","货源信息","车源信息"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
   end
   
    puts "01-click  line select-W090CargoPageTest"
    assert $browser.link(:id, "from_data_load").click;    sleep 1
    result=$browser.text.force_encoding('utf-8')
    ["出发城市","北京","吉林","黑龙江","重庆市","上海"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
    
    #click from 浙江
    assert $browser.link(:text, "浙江").click;     sleep 1
    result=$browser.text.force_encoding('utf-8')
   ["出发城市","杭州","北京","吉林","黑龙江","重庆市","上海"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
    assert $browser.link(:id, "from_data_load").click  #to close from select
    
   assert $browser.link(:id, "to_data_load").click; sleep 1
     result=$browser.text.force_encoding('utf-8')
   ["到达城市","北京","吉林","黑龙江","重庆市","上海"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
   # assert $browser.link(:id, "to_data_load").click;sleep 1
 
    
      #click to 浙江
    assert $browser.link(:text, "浙江").click; sleep 1   
    result=$browser.text.force_encoding('utf-8')
   ["到达城市","杭州","北京","吉林","黑龙江","重庆市","上海"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
    assert $browser.link(:id, "to_data_load").click  #to close to select
    
    #
    #click search
   assert $browser.link(:id, "search").click;  sleep 1  
   result=$browser.text.force_encoding('utf-8')
   ["车辆","浙江","关于物流零距离","货源信息","车源信息"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 



   #click next page search
   
  end
  
end
