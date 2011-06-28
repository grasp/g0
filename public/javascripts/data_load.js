/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function general_data_load(){

     //this is for panel data load toggle
    $("a.data_load" ).live("click",function()
    {
        
        var corordiate= $(this).offset();    

        var parent_coordiate=$(this).parent().parent().offset();
        
        selected=$(this).next();
         $("a.data_load").css("background-color","#D4E4FF");
        $(this).css("background-color","#ffcc00");
        if(selected.css("display")=="none")
        {
            selected.css("display","inline");
            selected.load(this.href);

        }
        else  selected.css("display","none");
        selected.css("top",corordiate.top+$(this).height()+10);
        selected.css("left",corordiate.left -100);
        

        if($.browser.msie) {
            event.returnValue = false;
            event.preventDefault();
            return false;
        }
        else   return false;
    });

    $(".data_list div ul li a" ).live("click",function()
    {
        var last_index=this.href.toString().lastIndexOf('/')
        var code =this.href.toString().substring(last_index+1);
        selected=$(this).parent().parent().parent().parent().parent();
        selected.load(this.href);
    

        selected.prev().text($(this).text());
        $(".data_load").css("background-color","#D4E4FF");
        selected.prev().css("background-color","#ffcc00");
            $(".data_list div ul li a" ).css("background-color","#D4E4FF");
        $(this).css("background-color","#ffcc00");
        selected.next().val(code);
        selected.next().next().val($(this).text());

        if($.browser.msie) {
            event.returnValue = false;
            event.preventDefault();
            return false;
        }
        else   return false;
    });

     $(".list_close a").live("click",function()
    {
        $('.data_list').css("display","none");

        if($.browser.msie) {
            event.returnValue = false;
            event.preventDefault();
            return false;
        }
        else   return false;
    });
}