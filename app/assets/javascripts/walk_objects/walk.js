var Walk = function(args) {
  args = args || {};
  this.name = args.name || "around Manhattan island"
  this.place = args.place || "New York City"
  this.miles = args.miles || 32;
  this.milesCompleted = args.milesCompleted || 0;
  this.leftBarProgress = this.getLeftBarProgress(this.milesCompleted);
  this.rightBarProgress = this.getRightBarProgress(this.milesCompleted);
  // not sure we will need to couple the objects but added it just in case
  this.user = args.user
}

Walk.prototype.getLeftBarProgress = function(miles) {
  if (miles >= 16) {
    return '100%';
  } else {
    return ((miles / 16) * 100).toString() + '%';
  }
};

Walk.prototype.getRightBarProgress = function(miles) {
  if (miles > 16) {
    return (((miles - 16) / 16) * 100).toString() + '%';
  } else {
    return '0%';
  }
};

// hard-coded to 32 miles
// will need refactoring if we ever want to make a series of different walks from the same total distance
Walk.makeWalks = function(totalDistance) {
  var walkCollection = new WalkCollection();

  if (totalDistance == 0) {
    var newWalk = new Walk({
      milesCompleted: 0
    })
    walkCollection.add(newWalk)
    debugger;
  }

  while (totalDistance > 0) {
    if (totalDistance >= 32) {
      var newWalk = new Walk({ milesCompleted: 32
      })

    } else {
      var newWalk = new Walk({
        milesCompleted: totalDistance
      })
    };
    walkCollection.add(newWalk);
    totalDistance -= 32;
  };
  $(walkCollection).trigger('walkchange');
  return walkCollection;
}

