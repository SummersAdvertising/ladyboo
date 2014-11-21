$(function() {
  var widthMove = $(window).width();

  if(widthMove<588){
      topHeight1 = $('.main-content').height();
      topHeight2 = $('.related').height();
      topHeight3 = $('.sidebar').height();
      $('.main-content').css({overflow:'hidden'});
      $('#content').css({height:topHeight1+topHeight2+topHeight3+300*widthMove/588,overflow:'hidden'});
      $('.sidebar').css({'margin-left':'-10px'})
      $('#category-filter').css({position:'absolute',top:topHeight1+topHeight2,width:'100%'});
      $('.related').css({position:'absolute',top:topHeight1,width:'96%','margin-left':'10px'});
    }

  

  $(window).resize(function(){
    widthMove = $(window).width();
    if(widthMove<588){
      topHeight1 = $('.main-content').height();
      topHeight2 = $('.related').height();
      topHeight3 = $('.panel-group').height();
      topHeight4 = $('#prodTop').height();
      $('.main-content').css({overflow:'hidden'});
      $('#content').css({height:topHeight1+topHeight2+topHeight3+topHeight4+20,overflow:'hidden'});
      $('.sidebar').css({'margin-left':'-10px'})
      $('#category-filter').css({position:'absolute',top:topHeight1+topHeight2,width:'100%'});
      $('.related').css({position:'absolute',top:topHeight1,width:'96%','margin-left':'10px'});
    }else{
      $('#category-filter').css({position:'static'});
      $('.related').css({position:'static'});
      $('.sidebar').css({'margin-left':'0px'});
      $('#content').css({height:'auto',overflow:'hidden'});
    }
  });
});     