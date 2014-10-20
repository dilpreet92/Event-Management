FactoryGirl.define do 
  factory :event do |t| 
    t.provider "twitter"
    t.name   "dp"
    t.access_token   "edeed"
    t.twitter_secret   "twitter_secret"
    t.uid   "uid"
    t.handle   'abc'
    t.enable  true
  end 
end