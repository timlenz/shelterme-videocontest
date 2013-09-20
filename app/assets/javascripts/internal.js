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
		// cross-browser compatibility for Firefox & IE - STILL NEEDS IE SUPPORT
		// var D = document;
		// 
		// Math.max(	Math.max(D.body.scrollHeight,    D.documentElement.scrollHeight),
		// 					Math.max(D.body.offsetHeight, D.documentElement.offsetHeight), 
		// 					Math.max(D.body.clientHeight, D.documentElement.clientHeight)
		// );
		// 
		// 
		// Math.max(
		//         $(document).height(),
		//         $(window).height(),
		//         /* For opera: */
		//         document.documentElement.clientHeight
		//     );
		var ie_height = document.documentElement.clientHeight;
		var ie_scroll = document.documentElement.scrollTop;	// kind of working
		var doc_height = Math.max( $(document).height(), window.innerHeight, ie_height );
		var vert_scroll = Math.max ( $('body').scrollTop(), window.scrollY, ie_scroll );
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
				
				// Submit All Video search by approval state on click
			  if ( $('#videos_search').length ) {
				  var $submit = form.find('input[name="search"]')
			    $.get($submit.action, $($submit).serialize(), null, 'script');
			    return false;
			  };
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
	$('a.video_link').click(function(){

		// Open video modal dialog
		$('#videoModal').dialog('open');

		// Get two sources for video, one each for mp4 and webm; stored in data-mp4 and data-webm tags
		var $mp4_source = $.trim($(this).attr("data-mp4"));
		var $webm_source = $.trim($(this).attr("data-webm"));
		var $poster = $.trim($(this).find('img').attr("src")); // Get poster image from clicked tile
		var $vid_obj = _V_("videoPlayer");
		var video_title = $(this).parents('.video-tile').find('.video-name h1').text();
		var video_id = $(this).parents('.video-tile').attr('data-video-id');
		$.cookie("video_id", video_id);
		var user_name = $(this).parents('.video-tile').find('.user_name').text();
		var user_link = $(this).parents('.video-tile').find('.user_name').attr('href');
		var user_location = $(this).parents('.video-tile').find('.user_location').text();
		var category_name = $(this).parents('.video-tile').find('li:eq(0)').find('a').attr('data-original-title');
		var category_icon = $(this).parents('.video-tile').find('li:eq(0)').find('a').attr('class');
		var ranking_name = $(this).parents('.video-tile').find('li:eq(1)').find('a').attr('data-original-title');
		var ranking_icon = $(this).parents('.video-tile').find('li:eq(1)').find('a').attr('class');
		var duration_name = $(this).parents('.video-tile').find('li:eq(2)').find('a').attr('data-original-title');
		var duration_icon = $(this).parents('.video-tile').find('li:eq(2)').find('a').attr('class');
		var vote_name = $(this).parents('.video-tile').find('li:eq(3)').find('a').attr('data-original-title');
		var vote_icon = $(this).parents('.video-tile').find('li:eq(3)').find('a').attr('class');
		var plays_name = $(this).parents('.video-tile').find('li:eq(4)').find('a').attr('data-original-title');
		var shares_name = $(this).parents('.video-tile').find('li:eq(5)').find('a').attr('data-original-title');
		var plays_count = $(this).parents('.video-tile').find('.plays').text();
		var shares_count = $(this).parents('.video-tile').find('.shares').text();

		// Make sure video is ready
		$vid_obj.ready(function(){

			// Assign variable to current player
			myPlayer = this;

			// Hide video UI
			$('video').hide();

			// Assign source to video object
			this.src([
			  { type: "video/mp4", src: $mp4_source },
			  { type: "video/webm", src: $webm_source }
			]);

			// Replace poster jpg
			$('.vjs-poster').css('background-image', 'url('+ $poster + ')').show();
			
			// Populate video data on bottom bar
			$('#videoModal').find('.video-name h1').text(video_title);
			$('#videoModal').find('.user_name').text(user_name);
			$('#videoModal').find('.user_name').attr('href',user_link);
			$('#videoModal').find('.user_location').text(user_location);
			$('#videoModal').find('ul').find('li:eq(0)').find('a').attr('class',category_icon);
			$('#videoModal').find('ul').find('li:eq(0)').find('a').attr('data-original-title',category_name);
			$('#videoModal').find('ul').find('li:eq(1)').find('a').attr('class',ranking_icon);
			$('#videoModal').find('ul').find('li:eq(1)').find('a').attr('data-original-title',ranking_name);
			$('#videoModal').find('ul').find('li:eq(2)').find('a').attr('class',duration_icon);
			$('#videoModal').find('ul').find('li:eq(2)').find('a').attr('data-original-title',duration_name);
			$('#videoModal').find('ul').find('li:eq(3)').find('a').attr('class',vote_icon);
			$('#videoModal').find('ul').find('li:eq(3)').find('a').attr('data-original-title',vote_name);
			$('#videoModal').find('ul').find('li:eq(4)').find('a').attr('data-original-title',plays_name);
			$('#videoModal').find('ul').find('li:eq(5)').find('a').attr('data-original-title',shares_name);
			$('#videoModal').find('.plays').text(plays_count);
			$('#videoModal').find('.shares').text(shares_count);

			// Populate sharing info
			$('#share').find('a').attr('href', function(i,val){
				return val.replace('videoID',video_id).replace('imageURL',$poster).replace('videoTITLE',encodeURIComponent(video_title)).replace('videoTITLE',encodeURIComponent(video_title)).replace('userNAME',encodeURIComponent(user_name));
			});
			$('#share_video_id').val(video_id);

			// Load new source
			this.load();
			$('video').show();
			
			// Add plays counter button when video is finished
			var modalPlayed = function(){
			  var myPlayer = this;
			  $('#play_video_id').val(video_id);
			};
			myPlayer.on("ended", modalPlayed);

		});
		return false;
	});
	
	// Stand-alone video player controls
	if ( $('#videoSolo').length ) {
		var $vid_obj = _V_("videoPlayer");
		var video_id = $('#videoSolo').attr('data-video-id');
		$.cookie("video_id", video_id, { path: '/'});
		$('#play_video_id').val(video_id);
		$vid_obj.ready(function(){
			myPlayer = this;
			$('video').show();
			var soloPlayed = function(){
			  $('#new_play').find('input[name=commit]').click();
			};
			myPlayer.on("ended", soloPlayed);
		});
	};
		
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
		// Stop video modal play on close
		$('#videoModal .close').click(function(){
			$('#videoModal').dialog('close');
			countPlay();
			resetPlayer();
		});
		// Stop video modal play on ESC
		$(document).keyup(function(e) {
			var keycode = (e.keyCode ? e.keyCode : e.which);	// capture keycode for Firefox
			if ( $('#videoModal').length && keycode == 27 ) {
				countPlay();
				resetPlayer();
			};
		});
	};
	
	if ( $('#previewModal').length && $('#addVideo').length == 0 ) {
		// Stop preview modal play on close
		$('#previewModal .close').click(function(){
			$('#previewModal').dialog('close');
			resetPlayer();
		});
		// Stop preview modal play on ESC
		$(document).keyup(function(e) {
			var keycode = (e.keyCode ? e.keyCode : e.which);	// capture keycode for Firefox
			if ( $('#previewModal').length && keycode == 27 ) { 
				resetPlayer();
			};
		});
	};
	
	$('#videoPlayer, #share').hover(
		function(){
			$('#share').show().removeClass('vjs-fade-out');
		}, function(){
			// $('#share').hide();
			$('#share').addClass('vjs-fade-out');
		}
	);
	
	// Increment video shares
	$('#share a').click(function(){
		$('#new_share').find('input[name=commit]').click();
	});
	
	function countPlay(){
		if ( $('#play_video_id').val() != '' ) {
			$('#new_play').find('input[name=commit]').click();
		};
		return;
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

	// Show progress bar on upload start
	$('.cloudinary-fileupload').bind('fileuploadstart', function() {  
  	$('#loadingPhoto, .handhold').show();
		$('button.close, .filedrop').hide();
		$('.cloudinary-fileupload').bind('fileuploadprogress', function(e, data){
			$('.mediaModal .headerInfo p').text(data.files[0].name);
			progress = parseInt(data.loaded / data.total * 100, 10);
			$('.progress .bar').css('width', progress + '%');
		});
	  return true;
	});

	// Show selected avatar photo name
	$('.cloudinary-fileupload input[type=file]').change(function(){
		var new_label = escape($('input[type=file]').val()).replace('C%3A%5Cfakepath%5C','');
		$('.mediaModal .headerInfo p').text("new_label");
	});
	
	// Reset form if photo upload failure
	$('.cloudinary-fileupload').bind('fail', function() {
		alert("Upload failed.");
  	$('#loadingPhoto, .handhold').hide();
		$('button.close, .filedrop').show();		
	});
	
	// Submit uploaded avatar info to db when uploaded
	$('#addAvatar .cloudinary-fileupload').bind('fileuploaddone', function() {
		$('.filedrop input[type=submit]').click();
	  $.cookie("avatar", "true");
	});
  
  // Explicitly set avatar cookie to false on Save click
  $('#saveUser, #saveUserAccount').click(function(){
    $.cookie("avatar", "false");
  });

	// All Videos Delete
  $("#videos .adminDelete a").click(function(){
    $("#deleteVideo").dialog('open');
    deleteVideoLink = "";
    $("#deleteVideo").parent().find(".ui-dialog-buttonset button").last().focus(); // Set focus on "delete" button in dialog
    var active = $(this);
    deleteVideoLink  = $.trim(active.attr("href"));
    var title = $.trim($(this).parents('.video-tile').find(".video-name h1").text());
    $("#deleteVideo h1").text("Delete " + title + "?");
    $("#deleteVideo .title").text(title);
    return false;	// prevents the default click behavior for delete button
  });
  
  $("#deleteVideo").dialog({
    autoOpen: false,
    resizable: false,
    draggable: false,
    closeOnEscape: false,
    width: 400,
    modal: true,
    buttons: {
      Cancel: function() {
        $(this).dialog("close");
      },
      "Delete": function() {
        $("#deleteVideo p, .ui-dialog-buttonset").hide();
        $("#deleteVideo .hide").show();
        $(".ui-dialog-title").text("Deleting...");
				$.post(deleteVideoLink, {"_method":"delete"}, function() {
					location.reload();
				})
      }
    }
  });

	// Edit video title
	$('.videoEdit a').click(function(){
		$("#editVideo").dialog('open');
		$("#video_title").focus(); // Set focus on text field in dialog
		var video_id = $(this).parents('.video-tile').attr('data-video-id');
		$.cookie("video_id", video_id);
		$.cookie("editTitle", "true", { expires: 1, path: '/' });
    titleChangeLink = $(this).parents('.videoEdit').find("input[type=submit]");
    var title = $.trim($(this).parents('.video-tile').find(".video-name h1").text());
		$("#editVideo").find('input').val(title);
		return false;
	});
	
	$('#editVideo').dialog({
		autoOpen: false,
    resizable: false,
    draggable: false,
		width: 400,
		closeOnEscape: true,
    modal: true,
		buttons: {
			Cancel: function() {
				$(this).dialog("close");
			},
			"Save": function() {
				var new_title = $("#editVideo").find('input').val();
				var video_id = $.cookie("video_id");
				$('*[data-video-id="'+video_id+'"]').find('.video-name h1').text(new_title);
				$('*[data-video-id="'+video_id+'"]').find('#video_title').val(new_title);
				$(this).dialog("close");
				titleChangeLink.click();
				// $.post(editVideoLink, $('#editVideo').find('form').serialize(), {"_method":"put"}, function() {
				// 	$('*[data-video-id="'+$video_id+'"]').find('.video-name h1').text(new_title);
				// }, "json");
			}
		}
	});
	
	// Sparklines for Statistics
  $('.sparklines').sparkline('html', { 
    zeroColor: '#999',
    barColor: '#999',
		barWidth: '20',
		barSpacing: '5',
		type: 'bar'
    // width: '100px'
  });

});