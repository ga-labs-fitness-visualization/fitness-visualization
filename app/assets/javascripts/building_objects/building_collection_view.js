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
  this.$el().empty();

  // var buildingCollectionView = this;
  this.collection.models.forEach(function(model){
    var newView = new BuildingView(model);
    newView.$el.css('left', (this.collection.models.indexOf(model) * 200).toString() + 'px');
    this.$el().append(newView.render().$el)
    newView.showProgress(newView.model.progress);
  }.bind(this))
}