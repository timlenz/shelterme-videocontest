$(function(){
	
	// Get dimensions of window and resize #content div
	if ( $('#landing').length ) {
		set_dimensions();
		$(window).resize(function() {
			set_dimensions();
		});
	};
	
	// Start the parallax effect by moving camera div
	$('html').mousemove(function(e){
		var movementStrength = 15;

		var height = movementStrength / $(window).height();
		var width = movementStrength / $(window).width();

	  var pageX = e.pageX - ($(window).width() / 2);
	  var pageY = e.pageY - ($(window).height() / 2);

	  var newvalueX = width * pageX * -1;
	  var newvalueY = height * pageY * -1;

	  $('#camera').css('left', newvalueX);
		$('#subject').css('left', -newvalueX);
	});
	
	function set_dimensions(){
		var native_image_h = 717;
		var native_image_w = 1432;
		var native_vid_h = 226;
		var native_vid_w = 390;
		var native_offset = 82;
		
		var window_h = $(window).height();
		var window_w = $(window).width();
		var window_ar = window_h / window_w;
		var doc_h = $(document).height();
		var doc_w = $(document).width();
		var doc_ar = doc_h / doc_w;
		var new_image_h = $('#camera').height();
		var new_image_w = $('#camera').width();
		var ar_point = 0.63

		if (window_ar >= ar_point) {
			var new_vid_h = Math.round(new_image_h * native_vid_h / native_image_h);
			var new_vid_w = Math.round(new_vid_h * native_vid_w / native_vid_h);
			var new_offset = Math.round(native_offset * new_vid_h / native_vid_h);
			$('#content').height(window_h);
		} else {
			var new_vid_w = Math.round(new_image_w * native_vid_w / native_image_w);
			var new_vid_h = Math.round(new_vid_w * native_vid_h / native_vid_w);
			var new_offset = Math.round(native_offset * new_vid_w / native_vid_w);
			if (window_h > 600) {
				var content_h = window_h;
				if ( $('html.hideScroll').length ) {
					$('html').removeClass('hideScroll');
				};
			} else {
				var content_h = 600;
				$(window).height(content_h);
				$('html').addClass('hideScroll');
			};
			$('#content').height(content_h);
		};	

		$('#video').height(new_vid_h).width(new_vid_w).css('top',new_offset);
		
		// Update text values
		/*$('.window').text(window_w + " " + window_h + " " + Math.round(window_h / window_w * 100));
		$('.camera').text(window_w + " " + new_image_h + " " + Math.round(new_image_h / window_h * 100));
		$('.video').text(new_vid_w + " " + new_vid_h);
		$('.position').text(new_offset);*/
	};
	
});