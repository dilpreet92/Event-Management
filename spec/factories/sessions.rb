FactoryGirl.define do 
  factory :session do |t|
    t.topic "dilpreet"
    t.start_date   Time.current + 2.day
    t.end_date   Time.current + 2.day + 12.hours
    t.location   "Hno. 1234"
    t.enable   true
    t.description 'ddqqdqdqd'
    event
  end
end