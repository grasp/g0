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
                required: true
            },
            "stock_cargo[cate_code]": {
                required: true
            },
            "stock_cargo[ku_weight]": {
                required: true,
                number: true
            },
            "stock_cargo[ku_bulk]": {
                required: true
            },

            name: {
                User_Format:true,
                required: true,
                minlength:1
            },
            password: {
                required: true,
                minlength:6
            },
            password_confirmation:{
                required: true,
                minlength:6,
                Check_same_password:true
            },
            email: {
                required: true
                //  email: true
            },
            QQ:{
                digits: true,
                minlength:5,
                maxlength:10,
                min:10000
            },
            mobile_phone:{
                required: true,
                digits: true,
                minlength:11,
                min:13000000000
            },
            phone_quhao:{
                minlength:3,
                maxlength:4
            },
            fix_phone: {
                minlength:7,
                maxlength:8
            },

            about: {
                required:true
            },
            num_employ: {
                digits:true
            },
            com_contact_name:{
                required:true
            },
            pai_zhao:{
                required:true
            },
            car_phone:{
                required:true
            },
            che_length:{
                required:true
            },
            dun_wei:{
                required:true
            },
            contact:{
                required:true
            },
            company:{
                required:true
            }

        },
        messages: {

            "stock_cargo[package_code]": {
                required: "包装不能为空"
            },
            "stock_cargo[cate_code]": {
                required: "货物不能为空"
            },
            "stock_cargo[ku_weight]": {
                required: "重量不能为空",
                number: "必须是数字"
            },
            "stock_cargo[ku_bulk]": {
                required: "请填写你估计的体积"
            },

            name: {
                required: "名字不能为空"
            },

            password: {
                required: "密码不能为空",
                minlength:"长度须大于6"
            },

            password_confirmation:{
                required: "密码确认不能为空",
                minlength:"长度须大于6"
            },
            email: {
                required: "email不能为空"
                //  email: "电子邮件格式不对"
            },
            QQ:{
                digits:"QQ号码不对",
                minlength:"长度小于5不对",
                maxlength:"长度不能大于10",
                min:"小于10000不对"
            },
            mobile_phone:{
                required: "手机号码不能为空",
                digits: "电话号码只能是数字",
                minlength:"电话号码长度不对",
                min:"非法电话号码"
            },
            phone_quhao:{
                minlength:"区号3位以上",
                maxlength:"区号不超过4位"
            },
            fix_phone: {
                minlength:"固定电话号码7位以上",
                maxlength:"固定电话号码最多8位"
            },
            about: {
                required:"公司介绍不能为空"
            },
            num_employ: {
                digits:"员工数量不对"
            },
            com_contact_name:{
                required:"联系人不能为空"
            },
            pai_zhao:{
                required:"牌照不能为空"
            },
            car_phone:{
                required:"随车电话不能为空"
            },
            che_length:{
                required:"车长不能为空"
            },
            dun_wei:{
                required:"吨位不能为空"
            },
            contact:{
                required:"联系人不能为空"
            },
            company:{
                required:"所属公司不能为空"
            }
        }
    });

    //to add custmer validate method
    jQuery.validator.addMethod("User_Format", function(value, element) {
        var re = new RegExp(/[a-z0-9.-_\u4E00-\u9FA5]+$/); //include hanzi/a-z0-9
        var re2 = new RegExp(/[\@\:\!\$\%\^\&\*\(\)\"\>\<\~\`]+$/); // exclude those symbole
        if (value.match(re)&&(!value.match(re2))) {
            //alert("Successful match");
            return true;
        } else {
            //  alert("No match");
            return false;
        }
    }, "用户名只能包含:汉字，字母，数字和下划线");

    //to add custmer validate method
    jQuery.validator.addMethod("Check_same_password", function(value, element) {
        var p=$(".cssform p input[name=password]").val();
        // alert(p);
        if (value==p) {
            //alert("Successful match");
            return true;
        } else {
            //  alert("No match");
            return false;
        }
    }, "确认密码和密码不一致");

}

function user_new_validation(){
      
    $("#user_new").validate(
    {

        rules: {
            "user[name]": {
                required: true,
                User_Format:true,
                minlength:3,
                maxlength:20
            },
            "user[email]": {
                required: true,
                email:true,
                minlength:6,
                maxlength:50
            },
            "email_confirm": {
                required: true,
                email:true,
                minlength:6,
                maxlength:50,
                Check_same_email:true
            },
            "user[password]": {
                required: true,
                minlength:6,
                maxlength:20
            },
            "user[password_confirmation]": {
                required: true,
                minlength:6,
                maxlength:20,
                Check_same_password:true
            }


        },
        messages: {

            "user[name]": {
                required: "用户名不能为空",
                minlength:"用户名长度需大于3",
                maxlength:"用户名长度需小于20"

            },
            "user[email]": {
                required: "email不能为空",
                email:"email格式不对",
                minlength:"密码长度不能小于6位",
                maxlength:"密码长度不能大于50位"
            },
            "email_confirm": {
                required: "email确认不能为空",
                email: "email格式不对",
                minlength:"密码长度不能小于6位",
                maxlength:"密码长度不能大于50位"
            },
            "user[password]": {
                required: "密码不能为空",
                minlength:"密码长度不能小于6位",
                maxlength:"密码长度不能大于20位"


            },
            "user[password_confirmation]": {
                required: "确认密码不能为空",
                minlength:"密码长度不能小于6位",
                maxlength:"密码长度不能大于20位"
            }
        }

    });

    //to add custmer validate method
    jQuery.validator.addMethod("User_Format", function(value, element) {
        var re = new RegExp(/[a-z0-9.-_\u4E00-\u9FA5]+$/); //include hanzi/a-z0-9
        var re2 = new RegExp(/[\@\:\!\$\%\^\&\*\(\)\"\>\<\~\`]+$/); // exclude those symbole
        if (value.match(re)&&(!value.match(re2))) {
            //alert("Successful match");
            return true;
        } else {
            //  alert("No match");
            return false;
        }
    }, "用户名只能包含:汉字，字母，数字和下划线");

    //to add custmer validate method
    jQuery.validator.addMethod("Check_same_password", function(value, element) {
        var p=$("#user_password").val();
        // alert(p);
        if (value==p) {
            //alert("Successful match");
            return true;
        } else {
            //  alert("No match");
            return false;
        }
    }, "确认密码和密码不一致");

    //to add custmer validate method
    jQuery.validator.addMethod("Check_same_email", function(value, element) {
        var p=$("#email_confirm").val();
        // alert(p);
        if (value==p) {
            //alert("Successful match");
            return true;
        } else {
            //  alert("No match");
            return false;
        }
    }, "确认email和email不一致");

}

function login_validation(){
    $("#login .show_form").validate(
    {

        rules: {
            "email": {
                required: true,
                minlength:3,
                maxlength:50
            },
            "password": {
                required: true,
                minlength:6,
                maxlength:20
            }

        },
        messages: {

            "email": {
                required: "登录名需为用户名或者email",
                minlength:"用户名长度需大于3",
                maxlength:"用户名长度需小于50"

            },
            "password":{
                required: "密码不能为空",
                minlength:"密码长度不能小于6位",
                maxlength:"密码长度不能大于20位"
            }
        }

    });

    //to add custmer validate method
    jQuery.validator.addMethod("User_Format", function(value, element) {
        var re = new RegExp(/[a-z0-9.-_\u4E00-\u9FA5]+$/); //include hanzi/a-z0-9
        var re2 = new RegExp(/[\@\:\!\$\%\^\&\*\(\)\"\>\<\~\`]+$/); // exclude those symbole
        if (value.match(re)&&(!value.match(re2))) {
            //alert("Successful match");
            return true;
        } else {
            //  alert("No match");
            return false;
        }
    }, "用户名只能包含:汉字，字母，数字和下划线");
}

function company_new_validation()
{
    $("#company_new,#company_edit").validate(
    {         

        rules: {
            "company[name]": {
                required: true,
                maxlength:100
            },
            "company[about]": {
                required: true,
                minlength:6,
                maxlength:500
            },
            "company[num_employ]":{
                number: true,
                maxlength:6
            },
            "company[signed_che]":{
                number: true,
                maxlength:6
            },
            "company[contact_name]":{
                required: true,
                minlength:2,
                maxlength:50
            },
            "company[city_name]":{
                required: true
            },
            "company[address]":{
                required: true

            },
            "company[fix_phone]":{
                minlength:7,
                maxlength:13,
                number:true
            },
            "company[mobile_phone]":{
                required: true,
                minlength:11,
                maxlength:11,
                number:true
            },
            "company[email]":{
                email:true
            },
            "quhao":{
                number:true,
                minlength:3,
                maxlength:4
            }


        },
        messages: {

            "company[name]": {
                required: "名字没有填写",
                maxlength:"长度需小于100"

            },
            "company[about]":{
                required: "介绍不能为空",
                maxlength:"长度500字以内"
            },
            "company[num_employ]":{
                number: true
            },
            "company[num_employ]":{
                number: "必须是数字",
                maxlength:"不对吧"
            },
            "company[signed_che]":{
                number: "必须是数字",
                maxlength:"不对吧"
            },
            "company[contact_name]":{
                required: "联系人没有提供",
                minlength:"名字不对，太短",
                maxlength:"名字不对，太长"
            },
            "company[city_name]":{
                required: "没有选择所在城市"
            },
            "company[address]":{
                required: "需要提供公司地址"

            },
            "company[fix_phone]":{
                minlength:"电话号码太短",
                maxlength:"电话号码太长",
                number:"必须是数字"
            },
            "company[mobile_phone]":{
                required: "提供一个手机吧",
                minlength:"长度不对",
                maxlength:"长度不对",
                number:"必须是数字"
            },
            "company[email]":{
                email:"email格式不对"
            },
            "quhao":{
                number:"区号必须是数字",
                minlength:"区号长度最短是3",
                maxlength:"区号长度最长是4"
            }
        }
    });
}

function usercontacts_new_validation()
{
    $("#usercontact_new").validate(
    {

        rules: {
            "usercontact[name]":{
                required:true,
                minlength:2,
                maxlength:20

            },
            "usercontact[QQ]":{
                number:true,
                minlength:6,
                maxlength:15

            },
            "usercontact[mphone]":{
                required:true,
                minlength:11,
                maxlength:11
            },
            "usercontact[quhao]":{
                minlength:3,
                maxlength:4
            },
            "usercontact[fixphone]":{ 
                minlength:7,
                maxlength:13
            }

        },

        messages:
            {
            "usercontact[name]":{
                required:"真实姓名没有填写",
                minlength:"长度不对",
                maxlength:"长度不对"

            },

            "usercontact[QQ]":{
                number:"号码需要是数字",
                minlength:"长度太短不对",
                maxlength:"长度太长不对"

            },
            "usercontact[mphone]":{
                required:"手机没有填写",
                minlength:"长度不是11位",
                maxlength:"长度不是11位"
            },
            "usercontact[quhao]":{
                minlength:"区号最小3位",
                maxlength:"区号最大4位"
            },
            "usercontact[fixphone]":{
                minlength:"电话号码太短",
                maxlength:"电话号码太长"
            }

        }


    });

}

function stock_cargo_new_validation(){

    $("#stockcargo_new").validate(
    {
        submitHandler: function(form) {
            $('#stockcargo_new').ajaxSubmit({
                // beforeSubmit:function(){ (stock_cargo_new_validation());},
                target: '#float_load',
                success: function() {
                    $("#show").load($("a.navi_stock_cargo").attr("href"));
                    $('#navi').load("/public/navibar");
                }
            });
            return false;
        },

        rules: {
            "stockcargo[cate_code]":{
                required: true
            },
            "stockcargo[package_code]":{
                required: true
            }
        },           
        messages: 
            {
            "stockcargo[cate_code]":{
                required: "你还没有选择货物类别"
            },
            "stockcargo[package_code]":{
                required: "你还没有选择包装类别"
            }
        }
    }
);     
}

function stock_truck_new_validation(){

    $("#stocktruck_new").validate(
    {
        submitHandler: function(form) {
            $('#stocktruck_new').ajaxSubmit({
                // beforeSubmit:function(){ (stock_cargo_new_validation());},
                target: '#float_load',
                success: function() {
                    $("#show").load($("a.navi_stock_truck").attr("href"));
                    $('#navi').load("/public/navibar");
                }
            });
            return false;
        },

        rules: {
            "stocktruck[paizhao]":{
                required: true,
                minlength:7,
                maxlength:8
            },
            "stocktruck[dun_wei]":{
                required: true,
                number:true,
                maxlength:5
            },
            "stocktruck[che_length]":{
                required: true,
                maxlength:5
            },
            "stocktruck[truck_shape]":{
                required: true,
                maxlength:5
            },
            "stocktruck[car_phone]":{
                required: true,
                maxlength:11,
                number:true
            },
            "stocktruck[driver_name]":{
                required: true,
                maxlength:10
            },
            "stocktruck[driver_phone]":{
                required: true,
                maxlength:11,
                number:true
            },
             "stocktruck[bis_name]":{
                required: true,
                maxlength:10
            },
            "stocktruck[bis_phone]":{
                required: true,
                maxlength:11,
                number:true
            },
             "stocktruck[owner_name]":{
                required: true,
                maxlength:10
            },
            "stocktruck[owner_phone]":{
                required: true,
                maxlength:11,
                number:true
            }
    
        },

        messages:
            {
            "stocktruck[paizhao]":{
                required: "没有填写牌照",
                minlength:"长度太短不对",
                maxlength:"长度太长不对"
            },
            "stocktruck[dun_wei]":{
                required: " 没有填写吨位",
                number: "需要是数字",
                maxlength:"长度太长不对"
            },
            "stocktruck[che_length]":{
                required: " 没有填写车厢长度",
                maxlength:"长度太长不对"
            },
            "stocktruck[truck_shape]":{
                required: "没有填写车厢结构",
                maxlength:"长度太长不对"
            },
            "stocktruck[owner_phone]":{
                required: " 没有填写车主电话",
                maxlength:"长度太长不对",
                number:"电话号码必须是数字"
            },
            "stocktruck[driver_name]":{
                required: " 没有填写 司机名称",
                maxlength:"长度太长不对"
            },
            "stocktruck[driver_phone]":{
                required: " 没有填写司机电话",
                maxlength:"长度太长不对",
                number:"电话号码必须是数字"
            },
              "stocktruck[bis_name]":{
                required: " 没有填写 联系人名称",
                maxlength:"长度太长不对"
            },
            "stocktruck[bis_phone]":{
                required: " 没有填写联系人电话",
                maxlength:"长度太长不对",
                number:"电话号码必须是数字"
            },
               "stocktruck[owner_name]":{
                required: " 没有填写 联系人名称",
                maxlength:"长度太长不对"
            },
            "stocktruck[owner_phone]":{
                required: " 没有填写联系人电话",
                maxlength:"长度太长不对",
                number:"电话号码必须是数字"
            }
        }
    }
    );
    }
function cargo_new_validation(){

    $("#cargo_new").validate(
    {
        submitHandler: function(form) {
                  $('#cargo_new').ajaxSubmit({
      // target: '#show',
       success: function() {
       $("#show").load($("a.navi_cargo").attr("href"));
       $('#navi').load("/public/navibar");
       $('a.navi_link').removeClass("navi_active");
       $("a.navi_cargo").addClass('navi_active');
        }
            });
            return false;
        },

        rules: {
            "cargo[fcity_name]":{
                required: true
            },
             "cargo[tcity_name]":{
                required: true
            },
             "cargo[cargo_weight]":{
                required: true
            }

        },

        messages:
            {
            "cargo[fcity_name]":{
                required: "你还没有选择出发地"
            },
             "cargo[tcity_name]":{
                required: "你还没有选择到达地"
            },
            "cargo[cargo_weight]":{
                required: " 没有填写重量"
            }

        }
    }
);
}

function truck_new_validation(){

    $("#truck_new").validate(
    {
        submitHandler: function(form) {
         $('#truck_new').ajaxSubmit({
       //  target: '#float_load',

       success: function() {
       $("#show").load($("a.navi_truck").attr("href"));
       $('#navi').load("/public/navibar");
       $('a.navi_link').removeClass("navi_active");
       $("a.navi_truck").addClass('navi_active');
        }
          });
            return false;
        },

        rules: {
            "truck[fcity_name]":{
                required: true
            }

        },

        messages:
            {
            "truck[fcity_name]":{
                required: "你还没有选择出发地"
            }

        }
    }
);
}

function inquery_new_validation(){

    $("#inquery_new").validate(
    {
        submitHandler: function(form) {
                  $('#inquery_new').ajaxSubmit({
       target: '#float_load',
       success: function() {
      
        }
       });
            return false;
        },

        rules: {
            "inquery[cargo_id]":{
                required: true
            }

        },

        messages:
            {
            "inquery[cargo_id]":{
                required: "你还没有货物"
            }

        }
    }
);
}

function quote_new_validation(){

    $("#quote_new").validate(
    {
        submitHandler: function(form) {
                  $('#quote_new').ajaxSubmit({
       target: '#float_load',
       success: function() {

        }
       });
            return false;
        },

        rules: {
            "quote[truck_id]":{
                required: true
            }

        },

        messages:
            {
            "quote[truck_id]":{
                required: "你还没有发布车源"
            }
        }
    }
);
 
}

function stock_truck_update_validation(){

  $("#stocktruck_edit").validate(
    {
      submitHandler: function(form) {

        $('#stocktruck_edit').ajaxSubmit({
      // beforeSubmit:function(){ (stock_cargo_new_validation());},
       target: '#float_load',
       success: function() {
       $("#show").load($("a.navi_stock_truck").attr("href"));
    }
  });
  return false;
    },

        rules: {
            "stocktruck[owner_name]":{
                required: true
            },
                "stocktruck[owner_phone]":{
                required: true
            },
             "stocktruck[driver_name]":{
                required: true
        },
        "stocktruck[driver_phone]":{
                required: true
        },
                "stocktruck[bis_name]":{
                required: true
        },
                "stocktruck[bis_phone]":{
                required: true
        }
        },
        messages:
        {
            "stocktruck[owner_name]":{
                required: "不能为空"
            },
                "stocktruck[owner_phone]":{
                required: "不能为空"
            },
             "stocktruck[driver_name]":{
                required: "不能为空"
           },
        "stocktruck[driver_phone]":{
                required: "不能为空"
        },
                "stocktruck[bis_name]":{
                required: "不能为空"
        },
                "stocktruck[bis_phone]":{
                required: "不能为空"
        }
        }
    }
)};












