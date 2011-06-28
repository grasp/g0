/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function line_search()
{

    $('input.cargo_search').live("click",function(){        
    from_city=$('a#from_data_load').attr("href").match(/\d\d\d\d\d\d\d+/)
    to_city=$('a#to_data_load').attr("href").match(/\d\d\d\d\d\d\d+/)
    search_url="/cargos/search/"+from_city+"/"+to_city+"/1"
   // $("#show").load(search_url)   
    window.location=search_url
 });
 
     $('input.truck_search').live("click",function(){        
    from_city=$('a#from_data_load').attr("href").match(/\d\d\d\d\d\d\d+/)
    to_city=$('a#to_data_load').attr("href").match(/\d\d\d\d\d\d\d+/)
    search_url="/trucks/search/"+from_city+"/"+to_city+"/1"
   // $("#show").load(search_url)
      window.location=search_url

 });
}
