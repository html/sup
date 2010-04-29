if (window.console && window.console.log) {
  window.l = window.console.log;
}

$(document).ready(function() {
    return;
	
  // show and hide block
  $('.slick-toggle').click(function() {
   $(this).next('.slickbox').slideToggle("slow");
  });
  
  $('.slick-toggle2').click(function() {
   $('.slickbox2:first').slideToggle("slow");
  });  

  $('.shut').click(function() {
  	$(this).parent().parent().find(".slickbox").slideToggle();
  });

  $("#from").attr("disabled", false);
  $("#to").attr("disabled", false);
  $("#autocomplete").attr("disabled", false);
  $("#autocomplete").attr("value", "");
  
  $("#autocomplete").focus(function() {
	$(this).autocomplete(data,{
		matchContains: true,
		minChars: 1,
		formatItem: function(row, i, max) {
			return row.to;
		},
		formatMatch: function(row, i, max) {
			return row.to;
		},
		formatResult: function(row) { 
			return row.to;
		}
	}).result(function(event, item) {
  	location.href = item.url;
	});  	
  });
  
	
  $('.dashed').mouseover(function() {
   $(this).removeClass("dashed");
   $(this).addClass("dashedhover");
  }).mouseout(function(){
   $(this).removeClass("dashedhover");
   $(this).addClass("dashed");
    });   
  
  $(".datepicker").datepicker();
  $(".datepicker2").datepicker(
   { 
   	 dateFormat: 'dd.mm.yy', 
   	 onSelect: function(dateText, inst) { $("#sub").css("visibility", "visible"); } 
   } 
  );
    
  $("#center").change( function() 
  {
	if($(this).val()>0)
	{
	 $('#theme_block').slideDown('slow');
	 
	 var list = document.getElementById("theme");
	 list.options.length = 0; 
	 
	 if(themes[$(this).val()])
	 {
	 	list.options[0] = new Option('Все специализации', 0);
	 	var j=1;
	    for (y=0; y < themes[$(this).val()].length; y++)
	    {
	     if(typeof(themes[$(this).val()][y]) != "undefined")
	     {	
	      list.options[j] = new Option(themes[$(this).val()][y], y);
	      j=j+1;
	     }
	    }	 	
	 }	 
	}
	else
	 $('#theme_block').slideUp('slow');
  }); 	
  
  
  $('#corp').click(function() 
  {
   var type = document.getElementById("type");
   type.value='corp';
   
   $('#corp').html("Корпоративный");
   $('#open_active').html("");
   $('#corp_active').html("<img src='/images/galka.gif'>");
   $('#open').html("<a href='#'>Открытый</a>");
   $('#open_block').slideUp('slow');
   
  }); 
  
  $('#open').click(function() 
  {
   var type = document.getElementById("type");
   type.value='open';
   
   $('#open').html("Открытый");
   $('#open_active').html("<img src='/images/galka.gif'>");
   $('#corp_active').html("");
   $('#corp').html("<a href='#'>Корпоративный</a>");   
   $('#open_block').slideDown('slow');
  });   
  

  $('#article').click(function() 
  {
   $('#release').removeClass("block2");
   $('#release').addClass("head10");
   
   $('#article').removeClass("head10");
   $('#article').addClass("block2");
  	
   $('#release_block').hide();
   $('#article_block').show();
  }); 
  
  $('#release').click(function() 
  {
   $('#article').removeClass("block2");
   $('#article').addClass("head10");
   
   $('#release').removeClass("head10");
   $('#release').addClass("block2");  	
  	
   $('#article_block').hide();
   $('#release_block').show();
  });    
  
});

 
$.fn.release_list=function()
{
 var b=this;
  $(b).find("li").each(function()
   {
    var c=$(this).find(".tooltip-container");
    $(this).children("a").leviTip({sourceType:"element",source:c,addClass:"tooltip",dropShadow:false})
   })
}; 

