var BottleCollection = function() {
  this.models = [];
}

BottleCollection.prototype.add = function(bottle) {
  this.models.push(bottle);
}