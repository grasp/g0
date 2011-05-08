/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function form_submit(){
    /*
     $('#stock_cargo_submit').live("click",function(){
    
      $('#stockcargo_new').ajaxSubmit({
      // beforeSubmit:function(){ (stock_cargo_new_validation());},
      target: '#float_load',
       success: function() {
       $("#show").load($("a.navi_stock_cargo").attr("href"));
       $('#navi').load("/public/navibar");
    }
  });
  return false;
});

 $('#stock_truck_submit').live("click",function(){
  // alert(" search_submit Hi");
      $('#stock_truck_new').ajaxSubmit({
      target: '#float_load',
       success: function() {
       $("#show").load($("a.navi_stock_truck").attr("href"));
       $('#navi').load("/public/navibar");
    }
  });
  return false;
});
*/
 $('#search_submit').live("click",function(){
  // alert(" search_submit Hi");
      $('.show_form').ajaxSubmit({
      target: '#show',
       success: function() {
       // alert("Hello Hunter!");
    }
  });
  return false;
});

/*

 $('#cargo_submit').live("click",function(){
   // alert("quote_submit Hi");
      $('#cargo_new').ajaxSubmit({
      target: '#float_load',
       success: function() {           
       $("#show").load($("a.navi_cargo").attr("href"));
       $('#navi').load("/public/navibar");
       $('a.navi_link').removeClass("navi_active");
       $("a.navi_cargo").addClass('navi_active');
    }
  });
  return false;
});

 $('#truck_submit').live("click",function(){
   // alert("quote_submit Hi");
      $('#truck_new').ajaxSubmit({
      target: '#float_load',
       success: function() {
    $("#show").load($("a.navi_truck").attr("href"));
       $('#navi').load("/public/navibar");
       $('a.navi_link').removeClass("navi_active");
       $("a.navi_truck").addClass('navi_active');
    }
  });
  return false;
});
*/

/*
 $('#user_contact_submit').live("click",function(){
   // alert("quote_submit Hi");
      $('#user_contact_new').ajaxSubmit({
      target: '#float_load',
       success: function() {
      //  alert("msg");
    }
  });
  return false;
});
*/
/*
 $('#inquery_submit').live("click",function(){
      $('#inquery_new').ajaxSubmit({
      target: '#float_load',
       success: function() {
       }
  });
  return false;
});

 $('#quote_submit').live("click",function(){
      $('#quote_new').ajaxSubmit({
      target: '#float_load',
       success: function() {
     
    }
  });
  return false;
});
*/
}

/*
 $('#companysearch_submit').live("click",function(){
   // alert("quote_submit Hi");
      $('#companysearch_new,#companysearch_edit').ajaxSubmit({
      target: '#show',
       success: function() {
    }
  });
  return false;
});
*/
/*
 $('#company_submit').live("click",function(){
   // alert("quote_submit Hi");
      $('#company_new,#company_edit').ajaxSubmit({
      target: '#show',
       success: function() {
    }
  });
  return false;
});

*/
