FactoryGirl.define do 
  factory :user do |t|
    t.provider "twitter"
    t.name   "dp"
    t.access_token   "edeed"
    t.twitter_secret   "twitter_secret"
    t.uid   "uid"
    t.twitter_name 'ddas'
    t.enabled  true
  end 
end