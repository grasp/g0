#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class W090CargoPageTest < ActiveSupport::TestCase

  test "public user search cargo" do
    puts "public user search cargo"
    $browser.goto("#$site_root")
    assert $browser.link(:id, "huo_info").click;    sleep 1
    result=$browser.text.force_encoding('utf-8')
    ["货物","出发地","到达地","有效期"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"}  
    
   #click page 2
   7.downto(2).each do |i|
   assert $browser.link(:href, "#{$site_root}/cargos/search/100000000000/100000000000/#{i}").click;  sleep 1  
   result=$browser.text.force_encoding('utf-8')
   ["关于物流零距离","货源信息","车源信息"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
   end
   
    puts "01-click  line select-W090CargoPageTest"
    line_select("浙江","杭州市","浙江","绍兴市")

   #click search
   assert $browser.link(:id, "search").click;  sleep 1  
   result=$browser.text.force_encoding('utf-8')
   ["货物","浙江","关于物流零距离","货源信息","车源信息"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 

   
  end
  
  
end
