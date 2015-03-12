$(function(){
  //get user id variable from url
  //kind of a hack but it works!
  var a = document.URL
  var id = a.substring(a.lastIndexOf('/') + 1, a.length);

  //these functions get floors and distance out of the json object
  //just placeholders until this is done in the back end
  var parseFloors = function(data) {
    var totalFloors = data["summary"]["floors"];
    return totalFloors;
  }

  var parseDistance = function(data) {
    var totalDistance = data["summary"]["distances"][0]["distance"];
    return totalDistance;
  }

  //set click handlers on buttons
  // success callback function will initiate the object creation/collection/render/animation process
  $('#get-data-day').click(function(){
    $.ajax({
      url: '/users/' + id,
      data: { duration: 1},
      dataType: 'json',
      method: 'GET',
      success: function(data){
        console.log(data);
        console.log('You climbed ' + parseFloors(data) + ' floors.');
        console.log('You moved ' + parseDistance(data) + ' miles.');
      }
    })
  });

  $('#get-data-week').click(function(){
    $.ajax({
      url: '/users/' + id,
      data: { duration: 7},
      dataType: 'json',
      method: 'GET',
      success: function(data){
        console.log(data);
      }
    })
  });

  $('#get-data-month').click(function(){
    $.ajax({
      url: '/users/' + id,
      data: { duration: 30},
      dataType: 'json',
      method: 'GET',
      success: function(data){
        console.log(data);
      }
    })    
  });

  // just testing out getting a building to render and animate on page load
  // this will NOT be part of the final code
  var esb = new Building();
  var testView = new BuildingView(esb);
  testView.render();
  testView.$el.css('left', '200px');
  $('#buildings').append( testView.$el );
  setTimeout(function(){
    testView.$bar.animate({height: "55%", }, 1000, 'easeInOutBack')
  }, 500);

})
