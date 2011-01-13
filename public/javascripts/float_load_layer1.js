/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function float_load_layer1(){


    /* 显示报价 或者询价 子页面 not for form submit ajax*/
    $('a.baojia,a.cargo_fabu,a.truck_fabu,a.show_float').live("click",function(){
        var corordiate= $(this).offset();
        var cord_left=corordiate.left;
        var cord_top=corordiate.top;

        selected=$('#float_show');
        
        var select_parent=$(this).parent().parent();

       $('tr').css("background-color","white");

       $('#float_load').empty();
       $('#float_load').load(this.href,function(){
     
           stock_cargo_new_validation();
           cargo_new_validation();
           truck_new_validation();
           inquery_new_validation();
           quote_new_validation();
       });

  

       css_class= $(this).attr("class");

            
             
        if(selected.css("display")=="none")
        {
           selected.css("display","inline");
        }
        else
        {
            
            selected.css("display","none");
             
             selected.css("display","inline"); 
            
        }


//        alert(select_parent.get(0).nodeName);
         if(select_parent.get(0).nodeName=="TR")
         {
           select_parent.css("background-color","#ffcc00");
         }
         /*
          $('#float_load').empty();
          $('#float_load').load(this.href);
          */
         //all float is below the click about one line, but middle of screen

          if(cord_top>($("#show").offset().top+$("#show").height()/2)+100)
          {
           selected.css("top",$("#show").offset().top);
          }
          else
          {
             selected.css("top",corordiate.top+30);
          }
              selected.css("left",$("#show").offset().left);
          /*
         if(cord_left>($("#show").width()/2))
          {
            selected.css("right",$("#main").width()-$("#show").width());
          }
          else
          {
             selected.css("left",$("#show").offset().left);
          }
*/
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