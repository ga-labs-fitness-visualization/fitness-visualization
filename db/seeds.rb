# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Clear out old junk data
User.destroy_all
DailyActivity.destroy_all

# Make new junk data
angelo = User.create(
	name: 'Angelo',
	email: 'angelo@example.com',
	)

DailyActivity.create(
	user_id: angelo.id,
	date: Date.new,
	floors: 10,
	distance: 3.3
	)