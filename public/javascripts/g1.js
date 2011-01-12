/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


$(document).ready(function() {
    var isfrom=true;
    var old_from=false;
    var from_city_code="330100000000";
    var to_city_code="340000000000";
    var options={
        target:  '#show'
    };
navi_js();
form_submit();
float_load_layer1();

    $(".delete").live("click",function()
    {
        var answer = confirm('删除吗？');
        return answer // answer is a boolean
    });
 
    $('.date-pick').datePicker();

   //form_validate();
    user_new_validation();
    login_validation();
stock_truck_new_validation();
   

     
    general_data_load();

    city_load();


  
});

