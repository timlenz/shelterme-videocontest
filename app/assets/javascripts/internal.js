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

	// Reposition sidebar if window is too short to avoid overlapping footer
	if ( $(window).height() < ($('#sidebar').height() + 100) ) {
		$('#sidebar').removeClass('affix').addClass('affix-bottom');
	} else {
		$('#sidebar').removeClass('affix-bottom').addClass('affix');
	};
	
	$(window).scroll(function(){
		if ( $(document).height() - $('body').scrollTop() < ($('#sidebar').height() + 100) ) {
			$('#sidebar').removeClass('affix').addClass('affix-bottom');
		} else {
			$('#sidebar').removeClass('affix-bottom').addClass('affix');
		};
	});

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
		$(this).find('.previewLink, .downloadLink').show();
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

	// Show video player modal
	$('a.previewLink').click(function(){
		$('#previewModal').dialog('open');
		var video = $.trim($(this).attr("href"));
		$('video').attr('src', video);
		return false;
	});
	
	$('a.videoTile').click(function(){
		$('#videoModal').dialog('open');
		var video = $.trim($(this).attr("href"));
		$('video').attr('src', video);
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
	
	if ( $('#videoModal').length ) {
		// Initialize video player
		videojs("#videoPlayer").ready(function(){
		  myPlayer = this;
		});
		// Stop video modal play on close
		$('#videoModal .close').click(function(){
			$('#videoModal').dialog('close');
			myPlayer.pause();
		});
		// Stop video modal play on ESC
		$(document).keyup(function(e) {
			if (e.keyCode == 27 && $('#videoModal').length ) {
				myPlayer.pause();
			};
		});
	};
	
	if ( $('#previewModal').length ) {
		// Initialize video player
		videojs("#previewPlayer").ready(function(){
		  myPlayer = this;
		});
		// Stop preview modal play on close
		$('#previewModal .close').click(function(){
			$('#previewModal').dialog('close');
			myPlayer.pause();
		});
		// Stop preview modal play on ESC
		$(document).keyup(function(e) {
			if (e.keyCode == 27 && $('#previewModal').length ) { 
				myPlayer.pause();
			};
		});
	};
	
	// Initialize date picker for user date of birth
	$("#user_date_of_birth").datepicker({
		dateFormat: "yy-mm-dd",
		yearRange: "1910:1995",
		changeMonth: true,
		changeYear: true,
		maxDate: "-18Y"	// User must be at least 18 to enter
  });

	// Hide Upload Video if mobile user agent
  if ( $('.mediaButtons').length) {
    if ( navigator.userAgent.match(/iPhone|iPod|Android|iPad|Tablet/i) != null ) {
      $('.mediaButtons').hide();
			$('#tabletAlert').show();
    };
  };

});