var BuildingCollectionView = function(collection) {
  this.collection = collection;
  // $(this.collection).on('change', console.log( this ));
  // $(this.collection).on('change', this.render.bind(this));
  $(this.collection).on('change', this.render());
}

BuildingCollectionView.prototype.$el = function() {
  return $('#buildings');
}

BuildingCollectionView.prototype.render = function() {
  $('#building-tweet-button').empty();
  $('#buildings-text').empty();
  this.$el().empty();

  this.collection.models.forEach(function(model){
    var newView = new BuildingView(model);
    var _this = this;
    this.$el().append(newView.render().$el);
    $( window ).scroll(function() {
        var aboveHeight = ( $('.dashboard-head').height() + $('#walks-text').height() + $('#walks').height() + $('#buildings-text').height() );
      if ( $(window).scrollTop() >= aboveHeight * 0.88 ) {
        setTimeout(function(){newView.showProgress(newView.model.progress)}, (_this.collection.models.indexOf(model) * 750 + 300));
      }
    })
  }.bind(this))
}