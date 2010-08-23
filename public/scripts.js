function tabulateMain(){
			$(function() {
				$(".tabs").tabs();
				$("button").button();
			});
			$(function() {
				$("#dialog-form").dialog({
					autoOpen: false,
					title: 'Add Torrent',
					height: 300,
					width: 350,
					modal: true,
					buttons: {
						Cancel: function(){
							$(this).dialog('close');
						},
						'Add Torrent': function(){
							//$("#dialog-form > form").submit()
							var fileInput = document.getElementById('the-file');
							var file = fileInput.files[0];
							
							var xhr = new XMLHttpRequest();
							xhr.open('POST', '/ajaxcmd?cmd=loadTorrent', true);
							xhr.setRequestHeader("X-File-Name", file.name);
							xhr.setRequestHeader("Content-Type", "application/octet-stream");
							xhr.send(file); // Simple!

							$(this).dialog('close');
						}
					}
				});
	
			$('#opener').click(function() {
				$("#dialog-form").dialog('open');
				// prevent the default action, e.g., following a link
				return false;
			});
		});
		function sendform(form){
			alert("LOLOLOL");
		}
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
	$(".header > img").click(function(event){
			id = $(this).parent().attr('id');
			$.get("/ajaxcmd", { cmd: "stopTorrent", id: id } );
			event.stopPropagation();
	})
}

