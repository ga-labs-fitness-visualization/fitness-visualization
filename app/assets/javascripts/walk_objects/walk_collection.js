var WalkCollection = function() {
  this.models = [];
}

WalkCollection.prototype.add = function(walk) {
  this.models.push(walk);
}