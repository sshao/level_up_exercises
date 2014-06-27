$ ->
  $(".close").on("click", (event)->
    $(this).parent().hide("slide", { direction: "up" }, "slow")
  )
