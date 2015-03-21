var BuildingView = function(model) {
  this.model = model
  this.$el = $('<div></div>').addClass('floors-progress');
  this.$bar = $('<div></div>').addClass('building-bar');
}

BuildingView.prototype.render = function() {
  var building = $('<div></div>').addClass('building');
  this.$el.append(building).append( this.$bar );
  // code for old building with mask layer
  // var building = $('<div></div>').addClass('building');
  // var buildingMask = $('<div></div>').addClass('building-mask');

  // this.$el.append(building).append(buildingMask).append( this.$bar );

  return this;
}

BuildingView.prototype.showProgress = function(height){
  this.$bar.animate({height: height, }, 1200, 'easeOutCirc');
}