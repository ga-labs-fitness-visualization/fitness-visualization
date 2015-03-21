var BottleView = function(model) {
  this.model = model;
  this.$el = $('<div></div>').addClass('calories-progress');
  this.$bar = $('<div></div>').addClass('bottle-bar');
}

BottleView.prototype.render = function() {
  var bottle = $('<div></div>').addClass('bottle');
  this.$el.append( bottle ).append( this. $bar );
  return this;
}

BottleView.prototype.showProgress = function(height){
  this.$bar.animate({height: height, }, 500, 'easeOutBack' );
}