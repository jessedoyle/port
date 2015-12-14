ready = ->
  setTimeout ->
    $('.app-messages').slideUp 400
  , 3000

$(document).ready ready
$(document).on 'page:load', ready