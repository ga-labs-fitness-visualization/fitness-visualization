var WalkView = function(model) {
  this.model = model;
  this.$el = $('<div></div>').addClass('miles-progress');
  this.$leftBar = $('<div></div>').addClass('walk-bar-left');
  this.$rightBar = $('<div></div>').addClass('walk-bar-right');
}

WalkView.prototype.render = function() {
  var walk = $('<div></div>').addClass('walk');
  this.$el.append( walk ).append( this.$leftBar ).append( this.$rightBar );

  return this;
}

WalkView.prototype.showProgress = function() {
  var _this = this;
  $( this.$leftBar ).animate({height: this.model.leftBarProgress, }, 1200);
  setTimeout(function(){
    console.log( _this );
    $( _this.$rightBar ).animate({height: _this.model.rightBarProgress, 
    }, 1200);
  }, 1200);
}