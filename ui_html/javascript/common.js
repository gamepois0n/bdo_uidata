/* faq list */
jQuery(function(){
	
	var article = $('.faq .article');

	article.addClass('hide');
	article.find('.a').slideUp(0); 
	
	$('.faq .article .q').click(function(){
		var myArticle = $(this).parents('.article:first');

		if(myArticle.hasClass('hide')){
			article.addClass('hide').removeClass('show'); 
			article.find('.a').slideUp(100); 
			myArticle.removeClass('hide').addClass('show');
			myArticle.find('.a').slideDown(100);
		} else {
			myArticle.removeClass('show').addClass('hide');
			myArticle.find('.a').slideUp(100);
		}
	}); 
});


$(document).ready(function(){	  
	$('.moreview').toggle(
		function(){  
			$(".more-view").slideDown(100) ;
			$("em.exText").text("Close Ranking") ;
			$(".ico").attr({src:"images/btn_more_top.gif"});  
			
		},
		function(){  
			$(".more-view").slideUp(100); 
			$("em.exText").text("View More Rankings") ;
			$(".ico").attr({src:"images/btn_more_ranking.gif"}); 
		}	
	)  
});

 


 