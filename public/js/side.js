$(function() {
  var widthMove = $(window).width();

  if(widthMove<588){
      topHeight1 = $('.main-content').height()+1840;
      topHeight2 = $('.related').height();
      topHeight3 = $('.sidebar').height();
      $('.main-content').css({overflow:'hidden'});
      $('#content').css({height:1400+topHeight1,overflow:'hidden'});
      $('.sidebar').css({'margin-left':'-10px'})
      $('#category-filter').css({position:'absolute',top:topHeight1+topHeight2+100,width:'100%'});
      $('.related').css({position:'absolute',top:topHeight1+100,width:'96%','margin-left':'10px'});
    }else{
      $('#category-filter').css({position:'static'});
      $('.related').css({position:'static'});
      $('.sidebar').css({'margin-left':'0px'});
      $('#content').css({height:'auto',overflow:'hidden'});
    }

  
  function move(){
    if(widthMove<588){
      topHeight1 = $('.main-content').height();
      topHeight2 = $('.related').height();
      topHeight3 = $('.sidebar').height();
      $('.main-content').css({overflow:'hidden'});
      $('#content').css({height:1400+topHeight1,overflow:'hidden'});
      $('.sidebar').css({'margin-left':'-10px'})
      $('#category-filter').css({position:'absolute',top:topHeight1+topHeight2+100,width:'100%'});
      $('.related').css({position:'absolute',top:topHeight1+100,width:'96%','margin-left':'10px'});
    }else{
      $('#category-filter').css({position:'static'});
      $('.related').css({position:'static'});
      $('.sidebar').css({'margin-left':'0px'});
      $('#content').css({height:'auto',overflow:'hidden'});
    }
  }
  $(window).resize(function(){
    widthMove = $(window).width();
    move();
  });
});     