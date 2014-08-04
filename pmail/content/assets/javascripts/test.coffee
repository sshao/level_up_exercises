$ ->
  $('.clickableRow').click( ->
    # TODO
  )

  $('#select-mail-input').next().click( ->
    value = !($('#select-mail-input').prop("checked"))

    inputs("all").each( ->
      $(this).prop("checked", value)
    )
  )

  $("#inbox-select a").click( ->
    inputs("all").each( ->
      $(this).prop("checked", false)
    )

    switch ($(this).attr("selector"))
      when "all"
        inputs("all").each( ->
          $(this).prop("checked", true)
        )
      when "none"
        inputs("all").each( ->
          $(this).prop("checked", false)
        )
      when "read"
        inputs("read").each( ->
          $(this).prop("checked", true)
        )
      when "unread"
        inputs("unread").each( ->
          $(this).prop("checked", true)
        )
      when "starred"
        inputs("starred").each( ->
          $(this).prop("checked", true)
        )
      when "unstarred"
        inputs("unstarred").each( ->
          $(this).prop("checked", true)
        )

    $("#inbox-select").foundation("dropdown", "close", $("#inbox-select"))
  )

inputs = (type) ->
  switch (type)
    when "all"
      return $(".checkbox").find("input")
    when "read"
      return $(".read").find("input")
    when "unread"
      return $(".unread").find("input")
    when "starred"
      return $(".lit-star").parent().parent().find("input")
    when "unstarred"
      return $(".star:not(.lit-star)").parent().parent().find("input")
    else
      return []
