$(function(){
  //get user id variable from url
  //kind of a hack but it works!
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

  var addSpinner = function() {
    $('#buildings').html('<p>Loading your data...</p>')
    var img = $("<img src='../assets/ajaxSpinner.gif'>").addClass('spinner');
    $('#buildings').append( img );
  }

  //set click handlers on buttons
  // success callback function will initiate the object creation/collection/render/animation process
  $('#get-data-day').click(function(){
    addSpinner();
    $.ajax({
      url: '/users/' + id,
      data: { duration: 1},
      dataType: 'json',
      method: 'GET',
      success: function(data){
        console.log(data);
        console.log('You climbed ' + parseFloors(data) + ' floors.');
        console.log('You moved ' + parseDistance(data) + ' miles.');
        var totalFloors = parseFloors(data);
        var buildingCollection = Building.makeBuildings(totalFloors);
        var buildingCollectionView = new BuildingCollectionView(buildingCollection);

      }
    })
  });

  $('#get-data-week').click(function(){
    addSpinner();
    $.ajax({
      url: '/users/' + id,
      data: { duration: 7},
      dataType: 'json',
      method: 'GET',
      success: function(data){
        console.log(data);
        var totalFloors = parseFloors(data);
        var buildingCollection = Building.makeBuildings(totalFloors);
        var buildingCollectionView = new BuildingCollectionView(buildingCollection);
      }
    })
  });

  $('#get-data-month').click(function(){
    // DO NOT DELETE!!!!
    // $.ajax({
    //   url: '/users/' + id,
    //   data: { duration: 30},
    //   dataType: 'json',
    //   method: 'GET',
    //   success: function(data){
    //     console.log(data);
    //     var totalFloors = parseFloors(data);
    //     var buildingCollection = Building.makeBuildings(totalFloors);
    //     var buildingCollectionView = new BuildingCollectionView(buildingCollection);
    //   }
    // })    
    // DO NOT DELETE!!!
      var totalFloors = 420
      var buildingCollection = Building.makeBuildings(totalFloors);
      var buildingCollectionView = new BuildingCollectionView(buildingCollection);
  });

})
