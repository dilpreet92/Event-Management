FactoryGirl.define do 
  factory :event do |t| 
    t.name "dilpreet"
    t.start_date   Time.current
    t.end_date   "edeed"
    t.address   "twitter_secret"
    t.city   "uid"
    t.country   'abc'
    t.contact_number  true
    t.description
    t.enable
    t.integer
    t.logo_file_name
    t.logo_content_type
    t.logo_file_size
    t.logo_updated_at
  end 
end