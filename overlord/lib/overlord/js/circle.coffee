$(document).on 'ready page:load', ->
  height = (($('.circle').height() - $('.content').height()) / 2)
  width = (($('.circle').width() - $('.content').width()) / 2)

  $(".content").css('margin-top', Math.abs(height) + 'px')
  $(".content").css('margin-left', Math.abs(width) + 'px')
