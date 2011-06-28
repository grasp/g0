/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function request_chenjiao(){
    $("a.request_chenjiao").live("click",function(){
        var answer=confirm("注意:该条货源将改为已成交状态,成交的货源和车源不能再接收新报价，请确保你已经联系并核实过该条车源,对方同意成交后再点击OK .确认请点击OK,取消请点Cancel"); 
        if(answer)
         { 
            $('#show').load(this.href); 
            $('#float_load').empty();
            $('#float_show').css("display","none");
            $('tr').css("background-color","white");             
         }
            if($.browser.msie) {
            event.returnValue = false;
            event.preventDefault();
            return false;
        }
        else   return false;
                
    });
}

function confirm_chenjiao(){
    $("a.confirm_chenjiao").live("click",function(){
        var answer=confirm("确认成交表示你和货主已经成功协商,货主或将可以评价你提供的服务"); 
        if(answer)
         { 
              $('#show').load(this.href); 
              $('#float_load').empty();
              $('#float_show').css("display","none");              
         }
    
            if($.browser.msie) {
            event.returnValue = false;
            event.preventDefault();
            return false;
        }
        else   return false;
                
    });
}

function float_load_layer1(){

    /* 显示报价 或者询价 子页面 not for form submit ajax*/
    $('a.baojia,a.cargo_fabu,a.truck_fabu,a.show_float').live("click",function(){

        var corordiate= $(this).offset();
        var cord_left=corordiate.left;
        var cord_top=corordiate.top;
        selected=$('#float_show');  
        
        var select_parent=$(this).parent().parent();
        var parent_coordiate=select_parent.offset();
       $('tr').css("background-color","white");
       $('#float_load').empty();
       $('#float_load').load(this.href,function(){     
           stock_cargo_new_validation();
           cargo_new_validation();
           truck_new_validation();
           inquery_new_validation();
           quote_new_validation();
           stock_truck_update_validation();
       });  

       css_class= $(this).attr("class");  
        if(selected.css("display")=="none")
        {
           selected.css("display","inline");
        }
        else
        {            
            selected.css("display","none");             
            selected.css("display","inline");    //????         
        }

         if(select_parent.get(0).nodeName=="TR")
         {
           select_parent.css("background-color","#ffcc00");
         }
           // ajust the location for each float
 
          if(cord_top>($("#show").offset().top+$("#show").height()/2)+100)
          {
           selected.css("top",$("#show").offset().top);
          }
          else
          {
             selected.css("top",corordiate.top+30);
          }
          
       //   selected.css("left",$("#show").offset().left);
       
         selected.css("left",corordiate.left);

         if ((this.href.match(/cargos\/show/))||(this.href.match(/trucks\/show/)))
          {
              selected.css("top",corordiate.top+$(this).height()+10);
              selected.css("left",corordiate.left);
          }   
         
         if ((this.href.match(/quotes/))||(this.href.match(/inqueries/)))
          {
           selected.css("top",corordiate.top+$(this).height()+10);
            selected.css("left",parent_coordiate.left);  
           }
         if($.browser.msie) {
                event.returnValue = false;
                event.preventDefault();
                return false;
            }
            else   return false;
    });

    $('a.float_close').live("click",function(){
        $('#float_show').css("display","none");
        $('tr').css("background-color","white");
          if($.browser.msie) {
                event.returnValue = false;
                event.preventDefault();
                return false;
            }
            else   return false;
    });


}