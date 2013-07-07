$(function(){
	
  // Dynamic Floating content indicator
  var min_height = 730; // For monitors with 800 px of vertical resolution, must account for menu bars & such
  // Show floater for short browser windows (onload)
  if ($(window).height() < min_height) {
    $('#floater').show();
  };
  // Hide floater for pages with content near the size of the window
  if ( $(document).height() <= ($(window).height() + 400) ) {
    $('#floater').hide();
  };
  // Show floater for resized windows
  $(window).resize(function(){
    if ( ($(window).height() <= min_height) && ($(document).height() > ($(window).height() + 200)) ) { 
      $('#floater').show();
    } else {
      $('#floater').hide();
    };
  });
  // Hide/show when scrolling
  $(window).scroll(function() {
    if (( ($(document).height() - $('body').scrollTop() - $(window).height()) > min_height ) && ($(window).height() <= min_height)) {
      $('#floater').show();
    } else {
      $('#floater').hide();
    };
  });
  // Scroll down on click and hide floater
  $('#floater').click(function() {
    $('#floater').hide();
    $('#mainContent').scrollTop($('#mainContent').scrollTop() + min_height);
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

});