 require File.dirname(__FILE__) + "/../config/environment"
 require 'csv'

CSV.foreach("#{Rails.root}/lib/data/admin.csv") do |row|
  @admin = Admin.new(:username => row[0], :password => row[1])
  @admin.save
end