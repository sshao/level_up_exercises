$ ->
  $('.clickableRow').click( ->
    # TODO
  )

  $('#select_mail_input').next().click( ->
    value = !($('#select_mail_input').prop("checked"))

    inputs("all").each( ->
      $(this).prop("checked", value)
    )
  )

  $("#inbox_select a").click( ->
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

    $("#inbox_select").foundation("dropdown", "close", $("#inbox_select"))
  )

inputs = (type) ->
  switch (type)
    when "all"
      return $(".checkbox").find("input")
    when "read"
      return $(".read").find("input")
    when "unread"
      return $(".unread").find("input")
    else
      return []
