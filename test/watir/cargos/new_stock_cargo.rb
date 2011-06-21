#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class W090NewStockCargoTest < ActiveSupport::TestCase

  
  def create_stock_cargo(big_cate,huo_dalei,huo_xiaolei,pack_dalei,pack_xiaolei)
    
   
    #click new stock cargo
   assert $browser.link(:text, "添加新的货物").click;sleep 0.2
   ["创建货物","货物大类","货物类别","货物包装"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
       
   $browser.select_list(:id, "stockcargo_big_category").set("#{big_cate}")
   #选择货物
   assert $browser.link(:text, "类别选择").click; sleep 0.2
   ["面谈","煤炭及制品","石油天然气及制品","货物大类"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
   
    assert $browser.link(:text, "#{huo_dalei}").click;sleep 0.2
    ["#{huo_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:text, "#{huo_xiaolei}").click;sleep 0.2
    ["#{huo_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:id, "list_closec").click;sleep 0.2
    ["#{huo_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    #选择包装
   assert $browser.link(:text, "包装选择").click;sleep 0.2
   ["包装大类","桶装","罐装","箱","袋装","特殊包装"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
   
    assert $browser.link(:text, "#{pack_dalei}").click;sleep 0.2
    ["#{pack_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
     assert $browser.link(:text, "#{pack_xiaolei}").click;sleep 0.2
    ["#{pack_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
   
   assert $browser.link(:id, "list_closep").click;sleep 0.2
    ["#{pack_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}

    assert $browser.button(:id, "stockcargo_submit").click;sleep 0.5
    ["货物创建成功","货物闲置",].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    $browser.link(:text, "关闭").click;sleep 0.2
    
  end
  test "user create a stock cargo" do
    puts "user create a stock cargo"
    logout_and_login
    assert $browser.link(:id, "fabu_huo").click; sleep 0.2
    ["请先添加货物","添加新的货物","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}

    create_stock_cargo("普通货物","石油天然气及制品","煤 油","特殊包装","其他包装")
    create_stock_cargo("普通货物","非金属矿石","磷矿石","袋装","麻袋")
  #  create_stock_cargo("大件货物","木 材","原 木","特殊包装","裸装")
  #  create_stock_cargo("普通货物","粮 食","小 麦","袋装","麻袋")
  #  create_stock_cargo("普通货物","机械设备电器","农林牧渔业机械","特殊包装","挂装")
   # create_stock_cargo("普通货物","肥料及农药","动植物肥料","袋装","麻袋")
  #  create_stock_cargo("普通货物","有色金属","铜","桶装","闭口钢桶")
    
    all_links=Array.new
    #now 发布货源
    $browser.links.each do |link|
      all_links << link.href.to_s if link.href.match("/cargos/new")
    end
    
    all_links.each do |old_link|       
    assert $browser.link(:id, "fabu_huo").click; sleep 0.5   #first click 发布货源 
    ["添加新的货物","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
     assert  $browser.link(:href, "#{old_link}").click;;sleep 0.4 #click each links we remembered
    ["请选择出发地","请选择到达地","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
  #line select
  #fill value
  #click
  
    end
  end
end
