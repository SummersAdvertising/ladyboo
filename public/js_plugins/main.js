  $(".pdquickview").click(function(){
      pd_id = $(this).data("pd").toString();
      $.ajax({
      type: "GET",
      url: "/products/"+pd_id+"/quickview",
      data: { },
      success: function(data){
        // $('#thumb li a').removeClass('active'); 
        // $('#thumb li a:first').addClass('active');
        //$('.bxslider').css({'-webkit-transition': '0s', 'transition': '0s', '-webkit-transform': 'translate3d(0px, -380px, 0px)'}); 
        
        $(".inline").colorbox({
          inline:true, 
          width:"925",
          height:"auto",
          href: "#inline_content",
          open: true
        });

        return false   
      },
      error: function(data){
        return false  
      }
    });
  });