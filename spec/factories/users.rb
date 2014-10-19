require 'faker'

FactoryGirl.define do 
  factory :user do |t| 
    t.provider "twitter"
    t.name   "dp"
    t.access_token   "access_token"
    t.twitter_secret   "twitter_secret"
    t.uid   "uid"
    t.handle   nil
    t.enable  true
  end 
end