var Walk = function(args) {
  args = args || {};
  this.name = args.name || "around Manhattan island"
  this.location = args.location || "New York City"
  this.distance = args.distance || 32;
  // not sure we will need to couple the objects but added it just in case
  this.user = args.user
}