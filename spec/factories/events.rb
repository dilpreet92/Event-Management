FactoryGirl.define do 
  factory :event do |t|
    t.name "dilpreet"
    t.start_date   Time.current + 1.day
    t.end_date   Time.current + 4.day
    t.address   "Hno. 1234"
    t.city   "Delhi"
    t.country   'India'
    t.contact_number  '131313'
    t.description 'ddqqdqdqd'
    t.enable true
    user
  end 
end