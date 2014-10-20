# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

Admin.delete_all
CSV.foreach("#{Rails.root}/lib/data/admin.csv") do |row|
  Admin.create!(:username => row[0], :password => row[1])
end

Admin.create(:username => 'dp', :password => 'dp')
