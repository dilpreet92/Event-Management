class EventSession < ActiveRecord::Base
  belongs_to :event
  validates :topic, :location, :description, presence: true
  validates :description, length: { maximum: 250 }
  validate :session_start_date_should_be_between_event_range
  validate :session_end_date_should_be_between_event_range

  def session_start_date_should_be_between_event_range
    if start_date < event.start_date || start_date > event.end_date
      errors.add(:start_date, 'Session should be present in the given event interval')
    end
  end

  def session_end_date_should_be_between_event_range
    if end_date > event.end_date || end_date < start_date
      errors.add(:end_date, 'Session should be present in the given event interval')
    end
  end

end
