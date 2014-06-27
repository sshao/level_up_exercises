$ ->
  $(".close").on("click", (event)->
    $(this).parent().hide("slow")
  )
