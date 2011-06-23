#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class W090NewStockTruckTest < ActiveSupport::TestCase
  
  def create_stock_truck(paizhao,weight,length,usage,chexiang,gps,jiaoche_person,
      jiaoche_phone,driver_person,driver_phone,owner,owner_phone,brand,xinghao,year)
    
        assert $browser.link(:id, "fabu_che").click; sleep 1
    ["新增车子","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:text, "新增车子").click; sleep 0.5   #first click 发布货源 
    ["创建车辆","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    $browser.text_field(:id,"stocktruck_paizhao").set(paizhao)
    $browser.text_field(:id,"stocktruck_dun_wei").set(weight)
    $browser.text_field(:id,"stocktruck_che_length").set(length)
    $browser.select_list(:id,"stocktruck_truck_usage").set(usage)
    $browser.select_list(:id,"stocktruck_truck_shape").set(chexiang)
    $browser.select_list(:id,"stocktruck_truck_gps").set(gps)
    $browser.text_field(:id,"stocktruck_bis_name").set(jiaoche_person)
    $browser.text_field(:id,"stocktruck_bis_phone").set(jiaoche_phone)
    $browser.text_field(:id,"stocktruck_driver_name").set(driver_person)
    $browser.text_field(:id,"stocktruck_driver_phone").set(driver_phone)
    $browser.text_field(:id,"stocktruck_owner_name").set(owner)
    $browser.text_field(:id,"stocktruck_owner_phone").set(owner_phone)      
    $browser.select_list(:id,"stocktruck_truck_pinpai").set(brand)
    $browser.text_field(:id,"stocktruck_truck_xinghao").set(xinghao)
    $browser.select_list(:id,"stocktruck_truck_year").set(year)
    
    #click create
    assert $browser.button(:id,"stocktruck_submit").click;sleep 1
    ["车辆闲置","#{paizhao}","司机电话","司机","车主","车主电话"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
  end
  
  def create_truck(from_province,from_city,to_province,to_city,day,huicheng)
    line_select(from_province,from_city,to_province,to_city)
    $browser.select_list(:id,"truck_send_date").set(day)
    $browser.select_list(:id,"truck_huicheng").set(huicheng)
    
    #need submit
    
    assert $browser.button(:id,"truck_submit").click;sleep 1
    ["#{from_province}","#{from_city}","#{to_province}","#{to_city}","有效天数","正在配货"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
  end

  test "user create a stock truck" do
    puts "user create a stock truck"
    logout_and_login


     create_stock_truck("浙#{$paizhao}","15","12","普通运输","平板","有","张三",
      "16578987654","李四","18765431234","王五","18765421258","东风货车","EST1000","2011")
    
     create_stock_truck("冀#{$paizhao}","25","11","大件运输","平板","无","张三",
      "16578987651","李四","18765431233","王五","18765421259","江淮货车","EST1001","2009")    

     create_stock_truck("豫#{$paizhao}","15","15","危险品专用","厢式车","无","张三",
      "16578987652","李四","18765431232","王五","18765421250","江淮货车","EST1002","2008") 
    
       create_stock_truck("鲁#{$paizhao}","15","15","冷藏保温","高栏","有","张三",
      "16578987655","李四","18765431231","王五","18765421257","福田货车","EST1002","2008") 
    
    all_links=Array.new
    #now 发布货源
    $browser.links.each do |link|
      all_links << link.href.to_s if link.href.match("/trucks/new")
    end
    
    all_links.each do |old_link|       
      assert $browser.link(:id, "fabu_che").click; sleep 0.5   #first click 发布车源 
      ["新增车子","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
      assert  $browser.link(:href, "#{old_link}").click;;sleep 0.4 #click each links we remembered
      ["请选择出发地","请选择到达地","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
      create_truck("浙江","杭州市","浙江","绍兴市","一天","回程车")
      
      #second line for same cargo
      assert $browser.link(:id, "fabu_che").click; sleep 0.5   #first click 发布货源
      ["正在配货"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
      assert  $browser.link(:href, "#{old_link}").click;;sleep 0.4 #click each links we remembered
      ["请选择出发地","请选择到达地","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
      create_truck( "河南","宝丰县","湖北","广水市","二天","本地车")
    end
  end
end
