FactoryGirl.define do 
  factory :session do |t| 
    t.topic "dilpreet"
    t.start_date   Time.current + 1.day
    t.end_date   Time.current + 2.day
    t.location   "Hno. 1234"
    t.enable   true
    t.event_id  1
    t.description 'ddqqdqdqd'
    association :event
  end 
end