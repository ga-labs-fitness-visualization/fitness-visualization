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


  var makeVisuals = function (data) {
    
    var totalDistance = parseDistance(data);
    var walkCollection = Walk.makeWalks(totalDistance);
    var walkCollectionView = new WalkCollectionView(walkCollection);
    addWalkText(data);
    addWalkTweetButton(data);


    var totalFloors = parseFloors(data);
    var buildingCollection = Building.makeBuildings(totalFloors);
    var buildingCollectionView = new BuildingCollectionView(buildingCollection);
    addBuildingText(data);
    addBuildingTweetButton(data);
  }

  var addWalkText = function(data) {
    $('#walks-text').append("<p>You walked around Manhattan " + (data.miles / 32).toFixed(2) + " times (" + data.miles.toFixed(2) + " miles).");
  }

  var addBuildingText = function(data) {
    $('#buildings-text').append("<p>You climbed the Empire State Building " + (data.floors / 102).toFixed(2) + " times (" + data.floors + " floors).")
  }

  var addWalkTweetButton = function(data){
    var url = document.URL;
    var text = 'I walked around Manhattan ' + (data.miles / 32).toFixed(2) + ' times on Fitcity!';
    twttr.widgets.createShareButton(
      url,
      document.getElementById('walk-tweet-button'),
      {
        count: 'none',
        text: text,
        size: 'large',
        related: 'fitbit'
      }).then(function (el) {
        console.log("Button created.")
    });
  }

  var addBuildingTweetButton = function(data){
    var url = document.URL;
    var text = 'I climbed the Empire State Building ' + (data.floors / 102).toFixed(2) + ' times on Fitcity!';
    twttr.widgets.createShareButton(
      url,
      document.getElementById('building-tweet-button'),
      {
        count: 'none',
        text: text,
        size: 'large',
        related: 'fitbit'
      }).then(function (el) {
        console.log("Button created.")
    });
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
