/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function get_full_name(code){
    
    if (code.match(/\d\d0000000000$/) )
    {
     selected=$("#float_load2 div div div a[href$="+code+"]")
     selected.css("background-color","#ffcc00");
     return selected.text();
    }
      
    else  if (code.match(/\d\d\d\d00000000$/)  && ( ! code.match(/\d\d0000000000$/)))
    {       
       province_code=code.slice(0,2)+"0000000000"
       $("#float_load2 div div div a[href$="+province_code+"]").css("background-color","#ffcc00");
       $("#float_load2 div div div a[href$="+code+"]").css("background-color","#ffcc00");
       return  $("#float_load2 div div div a[href$="+province_code+"]").text()+ $("#float_load2 div div div a[href$="+code+"]").text();
    }
         
    else if ((! code.match(/\d\d\d\d00000000$/)) && (! code.match(/\d\d0000000000$/)))
    {
      province_code=code.slice(0,2)+"0000000000"
      region_code=code.slice(0,4)+"00000000"
       $("#float_load2 div div div a[href$="+province_code+"]").css("background-color","#ffcc00");
       $("#float_load2 div div div a[href$="+region_code+"]").css("background-color","#ffcc00");
       $("#float_load2 div div div a[href$="+code+"]").css("background-color","#ffcc00");
      return  $("#float_load2 div div div a[href$="+province_code+"]").text()+$("#float_load2 div div div a[href$="+region_code+"]").text()+$("#float_load2 div div div a[href$="+code+"]").text();
    }
    return $("#float_load2 div div div a[href$="+code+"]").text();
}

function city_load(){
    var last_province_code=""
    var new_province_code=""

    $("#from_data_load,#to_data_load" ).live("click",function()
    {
            var coordinate=$("#from_data_load").offset();
            selected= $("#float_load2");
            /*IE not support inherit*/
          //$("#from_data_load,#to_data_load" ).css("background-color","inherit");
            if($("#float_show2").css("display")=="none")
            {
                $("#float_show2").css("display","inline");
                if($(this).attr("class")=="company_city")
                {
                    $("#float_show2").css("top",coordinate.top-400);
                    $("#float_show2").css("left",coordinate.left-400);
                }
                else{
                    $("#float_show2").css("top",coordinate.top+30);
                    $("#float_show2").css("left",coordinate.left);
                }
               $("#from_data_load,#to_data_load" ).css("background-color","#D4E4FF");
                 $(this).css("background-color","#ffcc00");
                 selected.empty();
                 selected.load(this.href,function(){                     
                 })
                //locate the position
            }
            else
            {
                $("#float_show2").css("display","none");
            }
            if($.browser.msie){
                event.returnValue = false;
                event.preventDefault();
                return false;
            }
            else   return false;
        });

    $("#float_load2 a.city_province,#float_load2 a.city_region,#float_load2 a.city" ).live("click",function()
    {        
        var last_index=this.href.toString().lastIndexOf('/')
        var code =this.href.toString().substring(last_index+1);
        thishref=this.href
            
        new_province_code=code.slice(0,2)+"0000000000"
        region_code=code.slice(0,4)+"00000000"   
        
        // alert("clicked1");
        $("#float_load2 div div div a" ).css("background-color","white");
       //  alert("clicked2");
         
        slected=$(this);   
      
        // if same province , do not load
        if (new_province_code!=last_province_code)
         {
            $("#float_load2").css("display","none");
            $("#float_load2").load(this.href,function(){                          
        });
          $("#float_load2").css("display","inline");
       }  
      
       if (thishref.match(/cities\/from/))
        {
           $("#selected_city").text(get_full_name(code));         
           $("#from_data_load").attr("href",thishref);
           $("#from_data_load").text($("#selected_city").text());  
          if ($("#search").length >0)
          {
            var action=$("#search").attr("href")
             new_action=action.replace(/search\/\d+/,"search/"+code)
            $("#search").attr("href",new_action)
          }
          else
           {
           $("#from_data_load").next().val(code);
           $("#from_data_load").next().next().val($("#selected_city").text());  
           }
        }

         if (thishref.match(/cities\/to/))
          {
            $("#selected_city").text(get_full_name(code));             
            $("#to_data_load").attr("href",thishref);           
            $("#to_data_load").text($("#selected_city").text());
            if ($("#search").length >0)
            {
            var action2=$("#search").attr("href");
            
            lastindex=action2.toString().lastIndexOf('/')
            lastcode =action2.toString().substring(lastindex+1);//fro recover the last number
            new_action=action2.replace(/\/\d+\/\d$/,"/"+code+"/"+lastcode)
           $("#search").attr("href",new_action)     
            }
            else
            {
              $("#to_data_load").next().val(code);
              $("#to_data_load").next().next().val($("#selected_city").text());
            }
            } 
            last_province_code=new_province_code
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