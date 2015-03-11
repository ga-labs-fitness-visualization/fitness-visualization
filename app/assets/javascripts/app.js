$(function(){
  var esb = new Building();
  var testView = new BuildingView(esb);
  testView.render();
  testView.$el.css('left', '200px');
  $('#buildings').append( testView.$el );
  setTimeout(function(){
    testView.$bar.animate({height: "55%", }, 1000, 'easeInOutBack')
  }, 500);
    $.ajax({
    url: '/users/1',
    data: { duration: 30},
    dataType: 'json',
    method: 'GET',
    success: function(data){
      console.log(data);
    }
  })
})