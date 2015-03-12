var BuildingView = function(model) {
  this.model = model
  this.$el = $('<div></div>').addClass('floors-progress');
  this.$bar = $('<div></div>').addClass('building-bar');
}

BuildingView.prototype.render = function() {
  var building = $('<div></div>').addClass('building');
  var buildingMask = $('<div></div>').addClass('building-mask');

  this.$el.append(building).append(buildingMask).append( this.$bar );

  return this;
}

BuildingView.prototype.showProgress = function(height){
  this.$bar.animate({height: height, }, 1500, 'easeInOutBack');
}