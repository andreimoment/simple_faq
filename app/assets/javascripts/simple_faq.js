$(document).ready(function(){

  // toggle answer
  $('[data-qa]').click(function(el){
    var questionID = $(this).data('qa');
    // uncomment to hide all other answers when showing the selected one
    // $('.faq--answer').not('.answer-' + questionID).addClass('hidden');
    $('.answer-' + questionID).toggle();
  })

})