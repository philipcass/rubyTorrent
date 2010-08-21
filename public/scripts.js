function tabulateMain(){
	$(function() {
		$(".tabs").tabs();
	});
}

function tabulateSub(){
	$(function() {
		$(".tabs-container").tabs({ 
			cache: true,
			spinner: '<img src="public/loading.gif"/>',
			ajaxOptions: {
				error: function(xhr, status, index, anchor) {
					$(anchor.hash).html("Loading...");
					$(".tabs-container").tabs('load', index); 
				}
			}
		});
	});
}

function setupAccoridion(){
	$(function(){
		$('.accordion').accordion({
			collapsible: true,
			active: false,
			icons: false,
			animated: false
		});
		$(".progressbar").progressbar({
			value: 37
		});
		$('.progressbar').each(function(index) {
			$(this).progressbar( "option", "value", parseInt($(this).children(":first").text()) );
  		});
	});
	$(".accordion").delegate("#header", "click", function(){
		var contentDiv = $(this).next();
		$.get('public/torrentinfo.html', function(data) {
			contentDiv.height( 300);
			contentDiv.html(data);
		});
	});
	$("#accor-store > .accordion").css("display", "block");

}

