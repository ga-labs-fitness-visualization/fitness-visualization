var BuildingCollection = function() {
  this.models = [];
}

BuildingCollection.prototype.add = function(building) {
  this.models.push(building);
  // let other models know this
}