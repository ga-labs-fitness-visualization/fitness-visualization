$(function(){
  
  var a = document.URL
  var id = a.substring(a.lastIndexOf('/') + 1, a.length);

  //these functions get floors and distance out of the json object
  //just placeholders until this is done in the back end
  var parseFloors = function(data) {
    var totalFloors = data["floors"];
    return totalFloors;
  }

  var parseDistance = function(data) {
    var totalDistance = data["miles"];
    return totalDistance;
  }

  // think we can lose this now... data loads quickly from db
  // var addSpinner = function() {
  //   $('#alerts').html('<p>Loading your data...</p>')
  //   var img = $("<img src='../assets/ajaxSpinner.gif'>").addClass('spinner');
  //   $('#alerts').append( img );
  // }

  var makeVisuals = function (data) {
    
    var totalDistance = parseDistance(data);
    var walkCollection = Walk.makeWalks(totalDistance);
    var walkCollectionView = new WalkCollectionView(walkCollection);
    addWalkText(data);


    var totalFloors = parseFloors(data);
    var buildingCollection = Building.makeBuildings(totalFloors);
    var buildingCollectionView = new BuildingCollectionView(buildingCollection);
    addBuildingText(data);
  }

  var addWalkText = function(data) {
    $('#walks-text').append("<p>You walked around Manhattan " + (data.miles / 32).toFixed(2) + " times (" + data.miles.toFixed(2) + " miles).");
  }

  var addBuildingText = function(data) {
    $('#buildings-text').append("<p>You climbed the Empire State Building " + (data.floors / 102).toFixed(2) + " times (" + data.floors + " floors).")
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
        makeVisuals(data);
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
        makeVisuals(data);
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
        makeVisuals(data);
      }
    })    
  });
})
