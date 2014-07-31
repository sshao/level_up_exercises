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
