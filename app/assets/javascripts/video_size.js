$(function() {

  $allVideos = $("iframe");

  $allVideos.each(function() {
    $(this).attr('aspectRatio', 90/144);

  });

  $(window).resize(function() {
    $allVideos.each(function() {
      $el = $(this);
      $el.height($el.width() * $el.attr('aspectRatio'));
      $el.parent().height($el.height());
    });
  }).resize();

});
