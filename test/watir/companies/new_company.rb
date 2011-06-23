#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class W090NewCompanyTest < ActiveSupport::TestCase

  def create_company(name,introduction,employer,truck,contact,city_province,city,address,quhao,fixphone,mobilephone,email)
    assert $browser.link(:text, "完善公司信息").click;sleep 0.5
    ["完善公司信息","公司名称","公司介绍","员工数量"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    $browser.text_field(:id, "company_name").set(name)
    $browser.text_field(:id, "company_about").set(introduction)
    $browser.text_field(:id, "company_num_employ").set(employer)
    $browser.text_field(:id, "company_self_che").set(truck)
    $browser.text_field(:id, "company_contact_name").set(contact)
     
    assert $browser.link(:id, "from_data_load").click;sleep 0.5
    ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:text, "#{city_province}").click;sleep 0.5
    ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
    assert $browser.link(:text, "#{city}").click;sleep 0.5
    ["#{city_province}","#{city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:id, "from_data_load").click;sleep 0.5
    ["#{city_province}","#{city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
    $browser.text_field(:id, "company_address").set(address)
    $browser.text_field(:id, "quhao").set(quhao)
    $browser.text_field(:id, "companyfix_phone").set(fixphone)
    $browser.text_field(:id, "company_mobile_phone").set(mobilephone)
    $browser.text_field(:id, "company_email").set(email)
    
    $browser.button(:id, "company_submit").click;sleep 1
    
   ["我的公司","货源信息","车源信息"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          
  end
  
  
  def test_private_user_create_company 
    puts "private user create company"
    logout_and_login
    create_company("#{$user_name}_汉江物流有限公司","我们是一家很棒的物流公司","20","5","张三丰","浙江","杭州市","石大路市场123号","0571","82876543","17898761234","hu@gmail.com")
   #now check information is there
    assert $browser.link(:text, "我的公司").click;sleep 0.5
    ["#{$user_name}_汉江物流有限公司","我们是一家很棒的物流公司","20","5","张三丰","浙江","杭州市","石大路市场123号","0571","82876543","17898761234","hu@gmail.com"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
  end
  
  
end
