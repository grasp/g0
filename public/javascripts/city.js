/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function city_load(){

    $("#from_data_load,#to_data_load" ).live("click",function()


    {
            var coordinate=$("#from_data_load").offset();
            selected= $("#float_load2");

            /*IE not support inherit*/

         //  $("#from_data_load,#to_data_load" ).css("background-color","inherit");
            if($("#float_show2").css("display")=="none")
            {
                  $("#float_show2").css("display","inline");
                if($(this).attr("class")=="company_city")
                {

                    $("#float_show2").css("top",coordinate.top-400);
                    $("#float_show2").css("left",coordinate.left-400);
                }else{
                    $("#float_show2").css("top",coordinate.top+30);
                    $("#float_show2").css("left",coordinate.left);
                }
               $("#from_data_load,#to_data_load" ).css("background-color","#D4E4FF");
                $(this).css("background-color","#ffcc00");
                selected.load(this.href);
               //locate the position
            }
            else
            {
                $("#float_show2").css("display","none");
            }

            if($.browser.msie) {
                event.returnValue = false;
                event.preventDefault();
                return false;
            }
            else   return false;
        });

    $("#float_load2  div ul li a" ).live("click",function()
    {
        var last_index=this.href.toString().lastIndexOf('/')
        var code =this.href.toString().substring(last_index+1);
        thishref=this.href
        slected=$(this);

        $("#float_load2").load(this.href,function(){
           
     
            if (thishref.match(/cities\/from/))
            {
                // $("#search_fcity_code").val(code);
                //  $("#search_fcity_name").val($("#selected_city").text());
                $("#from_data_load").next().val(code);
                $("#from_data_load").next().next().val($("#selected_city").text());
                $("#from_data_load").text($("#selected_city").text());

            }

            if (thishref.match(/cities\/to/))
            {
                $("#to_data_load").next().val(code);
                $("#to_data_load").next().next().val($("#selected_city").text());
                $("#to_data_load").text($("#selected_city").text());
            }

        });

        if($.browser.msie) {
            event.returnValue = false;
            event.preventDefault();
            return false;
        }
        else   return false;
    });

    $("a.float_close2").live("click",function()
    {
        $(this).parent().parent().css("display","none");

        if($.browser.msie) {
            event.returnValue = false;
            event.preventDefault();
            return false;
        }
        else   return false;
    });

    // for show folat2 classs
    $("a.show_float2,a.baojia" ).live("click",function()
    {
        var coordinate=$(this).offset();
        selected= $("#float_load2");

        $(this).css("background-color","inherit");
        if($("#float_show2").css("display")=="none")
        {
            $("#float_show2").css("display","inline");
            //determin the display location
 
            if($(this).attr("class")=="company_city")
            {

                $("#float_show2").css("top",coordinate.top-300);
                $("#float_show2").css("left",coordinate.left-300);
            }else{
                $("#float_show2").css("top",coordinate.top+30);
                $("#float_show2").css("left",coordinate.left);
            }
      
            $("a.show_float2").css("background-color","inherit");
            $(this).css("background-color","#ffcc00");
            selected.load(this.href);
        //locate the position
        }
        else
        {
            $("#float_show2").css("display","none");
        }

        if($.browser.msie) {
            event.returnValue = false;
            event.preventDefault();
            return false;
        }
        else   return false;
    });


};