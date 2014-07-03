$ ->
  $('#activate').submit (ev) ->
    ev.preventDefault()

    $.ajax '/activate',
      type: 'POST'
      data: $('#activate').serialize()
      success: (data, textStatus, jqXHR) ->
        console.log(data)
        $("div.state").html(data)
        #console.log(data.state)
        #$("span").html(data.state)
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"

$ ->
  $('#deactivate').submit (ev) ->
    ev.preventDefault()

    $.ajax '/deactivate',
      type: 'POST'
      data: $('#deactivate').serialize()
      success: (data, textStatus, jqXHR) ->
        console.log(data)
        $("div.state").html(data)
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"

