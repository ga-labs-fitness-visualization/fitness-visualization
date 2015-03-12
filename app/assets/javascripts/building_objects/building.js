var Building = function (args) {
  args = args || {}
  this.name = args.name || "the Empire State Building"
  this.place = args.place || "New York City"
  this.floors = args.floors || 102;
  this.floorsCompleted = args.floorsCompleted || 0;
  this.percentToTop = args.percentToTop || 85;
  this.progress = ((this.floorsCompleted / this.floors) * this.percentToTop).toString() + '%';
 
  // not sure we will need to couple the objects but added it just in case
  this.user = args.user
}

// hard-coded to 102 floors
// will need major refactoring / rethinking if we ever want to make a series of different buildings
Building.makeBuildings = function(totalFloors) {
  var dayBuildingCollection = new BuildingCollection();
  while (totalFloors > 0) {
    if (totalFloors >= 102) {
      var newBuilding = new Building({
        floorsCompleted: 102
      })

    } else {
      var newBuilding = new Building({
        floorsCompleted: totalFloors
      })
    };
    dayBuildingCollection.add(newBuilding);
    totalFloors -= 102;
  };
  console.log(dayBuildingCollection);
  $(dayBuildingCollection).trigger('change');
  return dayBuildingCollection;
}