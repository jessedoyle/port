var ready = function(){
  $('.datepicker').pickadate({
    format: 'yyyy-mm-dd'
  });
};

$(document).on('page:load', ready);
$(document).on('ready', ready);