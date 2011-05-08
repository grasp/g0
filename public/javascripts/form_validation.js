/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function form_validate(){
    //form common valiation part
    $(".show_form").validate(
    {
        rules: {

            "stock_cargo[package_code]": {
                required: true,
                minlength: 2
            }

        },
        messages: {
             "stock_cargo[package_code]": {
                required: "名字不能为空",
                minlength: "你没有选择包装"
            }

        }
    });
}


$(document).ready(function() {
    var isfrom=true;
    var old_from=false;
    var from_city_code="330100000000";
    var to_city_code="340000000000";
    var options={
        target:  '#show'
  };
   form_validate();
});