$ ->
  # FIXME refactor below line
  arr = $('div.exploded').find('*').not('input').not('label').not('button').not('strong').not('span').not('form')

  random_negation = () -> Math.round(Math.random()) * 2 - 1
  
  for val in arr 
    do ->
      $(val).css('position', 'relative');

      top = Math.floor((Math.random()*100)+1) * random_negation();
      left = Math.floor((Math.random()*100)+1) * random_negation();
      degree = Math.floor((Math.random()*360)+1)

      $(val).animate(
        {
          rotation: degree
          left: '+=' + left + '%'
          top: '+=' + top + '%'
        },
        {
          duration: 4000
          easing: 'easeOutQuint'
          step: (now) ->
            $(this).css('transform', 'rotate(' + now + 'deg)')
        }
      )

