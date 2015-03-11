var User = function(args) {
  args = args || {};
  this.name = args.name;
  this.floors_climbed = args.floors_climbed;
  this.distance_walked = args.distance_walked;
  this.buildings = [];
  this.walks = [];
}