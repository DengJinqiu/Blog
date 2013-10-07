resize = ->
  allVideos = $("iframe")

  allVideos.each( ->
    $(this).attr('aspectRatio', 90/144)

    $(window).resize( ->
      allVideos.each( ->
        el = $(this)
        el.height(el.width() * el.attr('aspectRatio'))
        el.parent().height(el.height())
      )
    )
  ).resize()

$(document).ready( ->
  resize()
)

$(document).on("page:load", ->
  resize()
)
