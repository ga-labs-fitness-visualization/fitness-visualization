var Bottle = function(args) {
  args = args || {};
  this.name = args.name || "a bottle of red wine";
  this.calories = args.calories || 625;
  this.caloriesCompleted = args.caloriesCompleted || 0;
  this.precentToTop = args.precentToTop || 85;
  this.progress = ((this.caloriesCompleted / this.calories) * this.precentToTop).toString() + '%';

  //maybe not needed now but could be useful for showing competition views
  this.user = args.user
}

//hard-coded to 625 calories
//will need refactoring if we ever want to make a series of different wines/foods

Bottle.makeBottles = function(totalCalories) {
  var bottleCollection = new BottleCollection();

  if (totalCalories == 0) {
    var newBottle = new Bottle({
      caloriesCompleted: 0
    })
    bottleCollection.add(newBottle);
  };

  while (totalCalories > 0) {
    if (totalCalories >= 625) {
      var newBottle = new Bottle({
        caloriesCompleted: 625
      })

    } else {
      var newBottle = new Bottle({
        caloriesCompleted: totalCalories
      })
    };
    bottleCollection.add(newBottle);
    totalCalories -= 625;
  };
  console.log(bottleCollection);
  $(bottleCollection).trigger('caloriechange');
  return bottleCollection;
}
