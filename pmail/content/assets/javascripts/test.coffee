$ ->
  $('.clickableRow').click( ->
    # TODO
  )

  $('#select_mail_input').next().click( ->
    $('#select_mail_input').prop("checked", (i, value) ->
      return !value
    )
  )
