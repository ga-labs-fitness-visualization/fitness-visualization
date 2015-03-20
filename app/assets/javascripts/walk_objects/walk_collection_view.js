var WalkCollectionView = function(collection) {
  this.collection = collection;
  $(this.collection).on('walkchange', this.render());
};

WalkCollectionView.prototype.$el = function() {
  return $('#walks');
};

WalkCollectionView.prototype.render = function() {
  $('#walk-tweet-button').empty();
  $('#walks-text').empty();
  this.$el().empty();

  this.collection.models.forEach(function(model){
    var newView = new WalkView(model);
    // newView.$el.css('top', '200px');
    // newView.$el.css('left', (this.collection.models.indexOf(model) * 250).toString() + 'px');
    this.$el().append(newView.render().$el);
    console.log(newView);
    setTimeout(function(){newView.showProgress();}, (this.collection.models.indexOf(model) * 2400));
  }.bind(this))
}