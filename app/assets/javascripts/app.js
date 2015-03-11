$(function(){
  var esb = new Building();
  var testView = new BuildingView(esb);
  testView.render();
  testView.$el.css('left', '200px');
  $('#buildings').append( testView.$el );
  setTimeout(function(){
    testView.$bar.animate({height: "55%", }, 1000, 'easeInOutBack')
  }, 500);
    // getting the user ID from the show page URL
    var a = document.URL
    var id = a.substring(a.lastIndexOf('/') + 1, a.length);
    console.log (id);
    console.log ('/users/' + id);
    $.ajax({
    url: '/users/' + id,
    data: { duration: 30},
    dataType: 'json',
    method: 'GET',
    success: function(data){
      console.log(data);
    }
  })
})