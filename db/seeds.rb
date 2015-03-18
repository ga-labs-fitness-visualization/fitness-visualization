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
	password_digest: '$2a$10$IiGzW86RjIvKfD/uClzmG.XRZ4HP5ZNUDaZq90mZql71uF/Nzc6Qq',
	session_token: "", 
	fitbit_token: "baa8b28ece74b50b77d4dc4bcb660cdb",
	fitbit_secret: "ea342798d031acb6a85c91cf90d274a3",
	fitbit_user_id: "37KCH8",
	avatar: "",
	)
rob = User.create(
	name: 'Rob',
	email: 'rob@example.com',
	password_digest: '$2a$10$IiGzW86RjIvKfD/uClzmG.XRZ4HP5ZNUDaZq90mZql71uF/Nzc6Qq',
	session_token: "", 
	fitbit_token: "ad29790e2d84a5a26ce4ed60a2b4f110",
	fitbit_secret: "fc4c33aa11e61f30076ecf289fcbd93e",
	fitbit_user_id: "39F8VY",
	avatar: "",
	)
