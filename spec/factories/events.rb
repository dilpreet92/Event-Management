FactoryGirl.define do 
  factory :event do |t| 
    t.name "dilpreet"
    t.start_date   Time.current + 1.day
    t.end_date   Time.current + 2.day
    t.address   "Hno. 1234"
    t.city   "Delhi"
    t.country   'India'
    t.contact_number  '131313'
    t.description 'ddqqdqdqd'
    t.enable true
    t.user_id 4 
    t.logo_file_name 'ddd'
    t.logo_content_type 'image/plain'
    t.logo_file_size '23'
    t.logo_updated_at Time.current
    association :session, strategy: :build
  end 
end