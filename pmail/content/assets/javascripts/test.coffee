$ ->
  $('.clickableRow').click( ->
    # TODO
  )

  $('#select_mail_input').next().click( ->
    value = !($('#select_mail_input').prop("checked"))

    $(".checkbox").each( ->
      $(this).find("input").prop("checked", value)
    )
  )

  $("#inbox_select a").click( ->
    switch ($(this).attr("selector"))
      when "all"
        $(".checkbox").each( ->
          $(this).find("input").prop("checked", true)
        )
      when "none"
        $(".checkbox").each( ->
          $(this).find("input").prop("checked", false)
        )

    $("#inbox_select").foundation("dropdown", "close", $("#inbox_select"))
  )
