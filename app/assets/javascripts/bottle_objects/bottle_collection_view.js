var BottleCollectionView = function(collection) {
  this.collection = collection;
  $(this.collection).on('caloriechange', this.render());
};

BottleCollectionView.prototype.$el = function() {
  return $('#wine');
};

BottleCollectionView.prototype.render = function() {
  $('#calorie-tweet-button').empty();
  $('#wine-text').empty();
  this.$el().empty();

  this.collection.models.forEach(function(model){
    var newView = new BottleView(model);
    var _this = this;
    this.$el().append(newView.render().$el);
    $( window ).scroll(function(){
      var wineTextOffset = $('#wine-text').offset().top;
      var scrollTop = $(window).scrollTop();
      if ( wineTextOffset - scrollTop <= 300 ) {
        console.log('got to the wine!');
        setTimeout(function(){newView.showProgress(newView.model.progress);}, (_this.collection.models.indexOf(model) * 500 + 100));
      }
    })
  }.bind(this))
}