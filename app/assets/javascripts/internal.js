$(function(){
	
  // Hover tooltip for video tile icons
  $('[rel=tooltip]').tooltip({
		container: 'body'
	});	
	
  // Dynamic Floating content indicator
  // var min_height = 730; // For monitors with 800 px of vertical resolution, must account for menu bars & such
  // // Show floater for short browser windows (onload)
  // if ($(window).height() < min_height) {
  //   $('#floater').show();
  // };
  // // Hide floater for pages with content near the size of the window
  // if ( $(document).height() <= ($(window).height() + 400) ) {
  //   $('#floater').hide();
  // };
  // // Show floater for resized windows
  // $(window).resize(function(){
  //   if ( ($(window).height() <= min_height) && ($(document).height() > ($(window).height() + 200)) ) { 
  //     $('#floater').show();
  //   } else {
  //     $('#floater').hide();
  //   };
  // });
  // // Hide/show when scrolling
  // $(window).scroll(function() {
  //   if (( ($(document).height() - $('body').scrollTop() - $(window).height()) > min_height ) && ($(window).height() <= min_height)) {
  //     $('#floater').show();
  //   } else {
  //     $('#floater').hide();
  //   };
  // });
  // // Scroll down on click and hide floater
  // $('#floater').click(function() {
  //   $('#floater').hide();
  //   $('#mainContent').scrollTop($('#mainContent').scrollTop() + min_height);
  // });

	// Reposition sidebar if window is too short
  $(window).scroll(function() {
		// cross-browser compatibility for Firefox & IE
		var ie_height = document.body.offsetHeight;
		var ie_scroll = $('body').scrollTop;
		var doc_height = Math.max( $(document).height(), window.innerHeight, document.body.offsetHeight );
		var vert_scroll = Math.max ( $('body').scrollTop(), window.scrollY, window.pageYOffset );
		var min_height = $('#sidebar').height() + $('header').height() + $('footer').height() + 15;	// includes sidebar top margin
    if ( (doc_height - vert_scroll) <= min_height ) {	
			var new_top = doc_height - $('#sidebar').height() - $('footer').height() - 20;
      $('#sidebar').removeClass('affix').addClass('affix-bottom').css('top',new_top);
    } else {
      $('#sidebar').removeClass('affix-bottom').addClass('affix').css('top','');
    };
		$('#scroll').text(vert_scroll);
		$('#ieScroll').text(ie_scroll);
		$('#height').text(doc_height);
		$('#ieHeight').text(ie_height);
		$('#top').text(new_top);
  });

	// Set sidebar left position (addresses Firefox layout issue)
	if ( $('#sidebar').length ) {
		var set_left = ( $(window).width() - $('.container').width() ) / 2;
		$('#sidebar').css('left',set_left).show();
	};

  // Automatically hide alert dialog after slight delay
  if($('.errorBox').is(':visible')) {
    $('#mainError').delay(3000).fadeOut('slow');
  };

  // Check if profile .headerInfo h1 field is too long and adjust font-size if needed
  if ($('.headerInfo h1').length) {
    var element = document.querySelector('.headerInfo h1');
    var default_height = 36;
    if (element.offsetHeight > default_height) {
      $('.headerInfo h1').css('font-size','22px');
    };
  };

	// Show links on mouse-over of assets
	$('.videoClip, .photoAsset').mouseover(function(){
		if ( navigator.userAgent.match(/iPhone|iPod|Android|iPad|Tablet/i) != null ) {
			$(this).find('.previewLink').show();
		} else {
			$(this).find('.previewLink, .downloadLink').show();
		};
	});
	
	$('.videoClip, .photoAsset').mouseout(function(){
		$(this).find('.previewLink, .downloadLink').hide();
	});
	
	// Connect graphic buttons with hidden input elements
	$('div.btn-group[data-toggle-name]').each(function(){
	  var group   = $(this);
	  var form    = group.parents('form').eq(0);
	  var name    = group.attr('data-toggle-name');
	  var hidden  = $('input[name="' + name + '"]', form);
	  var current_value;
	  $('button', group).each(function(){
	    var button = $(this);
	    button.on('click', function(){
	      current_value = hidden.val();
				hidden.val($(this).val());
	    });
	    if(button.val() == hidden.val()) {
	      // Set clicked button to active
	      button.addClass('active');
	    };
	  });
	});
	
	// Target asset preview
	$('a.previewLink').click(function(){

		// Open video modal dialog
		$('#previewModal').dialog('open');

		var $source = $.trim($(this).attr("href")); // Find new source movie from clicked tile
		var $path = "http://smvideocontest.s3.amazonaws.com/video/";
		var $vid_obj = _V_("previewPlayer");
		// Make sure video is ready
		$vid_obj.ready(function(){

			// Assign variable to current player
			myPlayer = this;

			// Hide video UI
			$('video').hide();

			// Assign source to video object
			this.src([
			  { type: "video/mp4", src: $path+$source+".mp4" },
			  { type: "video/webm", src: $path+$source+".webm" }
			]);

			// Replace poster jpg
			$('.vjs-poster').css('background-image', 'url('+ $path + $source + '.jpg)').show();

			// Load new source
			this.load();
			$('video').show();

		});
		return false;
	});
	
	// Target video tile
	$('.tile-photo a').click(function(){

		// Open video modal dialog
		$('#videoModal').dialog('open');

		var $source = $.trim($(this).attr("href")); // Find new source movie from clicked tile
		var $path = "http://smvideocontest.s3.amazonaws.com/video/";
		var $vid_obj = _V_("videoPlayer");

		// Make sure video is ready
		$vid_obj.ready(function(){

			// Assign variable to current player
			myPlayer = this;

			// Hide video UI
			$('video').hide();

			// Assign source to video object
			this.src([
			  { type: "video/mp4", src: $path+$source+".mp4" },
			  { type: "video/webm", src: $path+$source+".webm" }
			]);

			// Replace poster jpg
			$('.vjs-poster').css('background-image', 'url('+ $path + $source + '.jpg)').show();

			// Load new source
			this.load();
			$('video').show();

		});
		return false;
	});
		
	$('#previewModal').dialog({
		autoOpen: false,
    resizable: false,
    draggable: false,
		width: 770,
		height: 460,
		closeOnEscape: true,
    modal: true
	});
	
	$('#videoModal').dialog({
		autoOpen: false,
    resizable: false,
    draggable: false,
		width: 770,
		height: 500,
		closeOnEscape: true,
    modal: true
	});
	
	if ( $('#videoModal').length && typeof myPlayer !== 'undefined' ) {
		// Stop video modal play on close
		$('#videoModal .close').click(function(){
			$('#videoModal').dialog('close');
			resetPlayer();
		});
		// Stop video modal play on ESC
		$(document).keyup(function(e) {
			var keycode = (e.keyCode ? e.keyCode : e.which);	// capture keycode for Firefox
			if ( keycode == 27 && $('#videoModal').length ) {
				resetPlayer();
			};
		});
	};
	
	if ( $('#previewModal').length && typeof myPlayer !== 'undefined' ) {
		// Stop preview modal play on close
		$('#previewModal .close').click(function(){
			$('#previewModal').dialog('close');
			resetPlayer();
		});
		// Stop preview modal play on ESC
		$(document).keyup(function(e) {
			var keycode = (e.keyCode ? e.keyCode : e.which);	// capture keycode for Firefox
			if ( keycode == 27 && $('#previewModal').length ) { 
				resetPlayer();
			};
		});
	};
	
	function resetPlayer(){
		myPlayer.pause();
		myPlayer.currentTime(0);
		$('video').hide();
		$('.vjs-loading-spinner').hide();
	};
	
	// Initialize audio player on click
	$('.audioPlay').click(function(){
		
		$(this).hide();
		$(this).parent().find('.audioPause').show();
		
		var $audio_obj = $(this).parent().find('.jplayer');
		var $source = $audio_obj.attr("data-media"); // Find new source audio from clicked play button
		var $path = "http://smvideocontest.s3.amazonaws.com/audio/";
		var $parentId = '#' + $(this).parents('.audioTrack').attr('id');
		
		$audio_obj.jPlayer({
			ready: function (event) {
        $(this).jPlayer("setMedia", {
          mp3: $path+$source+".mp3",
					oga: $path+$source+".ogg"
        });

				$audio_obj.bind($.jPlayer.event.play, function() { // Bind an event handler to the instance's play event.
				  $(this).jPlayer("pauseOthers"); // pause all players except this one.
					$(this).parents('.tab-pane').find('.trackCurrentTime').removeClass('show');
					$(this).parents('.audioTrack').find('.trackCurrentTime').addClass('show');
				});

				$(this).bind($.jPlayer.event.pause, function() {
		      $(this).parents('.audioTrack').find('.trackCurrentTime').removeClass('show');
		    });
		
				$(this).bind($.jPlayer.event.ended, function() {
					$(this).parents('.audioTrack').find('.trackCurrentTime').removeClass('show');
				});

				$(this).jPlayer("play");
				
	    },
	    swfPath: "/",
	    supplied: "mp3, oga",
			keyEnabled: true,
			cssSelectorAncestor: $parentId,
			cssSelector: {
			  play: ".audioPlay",
			  pause: ".audioPause",
			  currentTime: ".trackCurrentTime .trackTimer"
			}
		});
	});
	
	// Initialize date picker for user date of birth
	$("#user_date_of_birth").datepicker({
		dateFormat: "yy-mm-dd",
		yearRange: "1910:1995",
		changeMonth: true,
		changeYear: true,
		maxDate: "-18Y"	// User must be at least 18 to enter
  });

	// Hide Upload Video if mobile user agent
  if ( $('.mediaButtons').length ) {
    if ( navigator.userAgent.match(/iPhone|iPod|Android|iPad|Tablet/i) != null ) {
      $('.mediaButtons').hide();
			$('#tabletAlert').show();
    };
  };

});