/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function navi_js(){
/*
$("#navi").ready(function(){
    $('.navi_block ul li a div').hover(
        //$('.navi_block ul li').hover(
        function () {
            $(this).css("background-color","#D4E4FF");
            return false;
        },
        function () {
             $(this).css("background-color","inherit");
             $(this).css("color","inherit");
            return false;
        });


});
*/
//Ajax for all navi link
$('a.navi_link').live("click",function(){
    $('#show').load(this.href,function(){
 });

    $('a.navi_link').removeClass("navi_active");
    $(this).addClass("navi_active");
       return false;
    });

$(".page_navi_link,div.page_navi_link a").live("click",function(){
    $('#show').load(this.href,function(){

    stock_truck_new_validation();
 });
     return false;
    });
}