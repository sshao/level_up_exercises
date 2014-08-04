$ ->
  $(document).keydown( (e) ->
    current = $(".selected")
    if (isEmpty(current))
      current = $(".inbox tr:first")
      current.addClass("selected")
      return

    switch(e.which)
      when 38
        if (!isEmpty(current.prev()))
          current.removeClass("selected")
          current.prev().addClass("selected")
      when 40
        if (!isEmpty(current.next()))
          current.removeClass("selected")
          current.next().addClass("selected")
  )

isEmpty = (arr) ->
  return arr.length == 0
