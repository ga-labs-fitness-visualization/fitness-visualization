var Building = function (args) {
  args = args || {}
  this.name = args.name || "the Empire State Building"
  this.location = args.location || "New York City"
  this.floors = args.floors || 102;
  // not sure we will need to couple the objects but added it just in case
  this.user = args.user
}