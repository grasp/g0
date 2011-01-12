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

function stock_truck_new_validation(){
    $("#stock_truck_new").validate(
    {

        rules: {
            "stock_truck[paizhao]": {required: true}
        },
           
        messages: 
            {"stock_truck[paizhao]": 
                {              required: "你还没有选择货物类别"            }
            }
        

    });
    }








