class EventSession < ActiveRecord::Base
  #FIXME_AB: as discussed rename this model too.
  
  belongs_to :event
  #FIXME_AB: :dependent?
  has_many :user_session_associations
  has_many :attending_users, through: :user_session_associations, source: :user

  validates :topic, :location, :description, presence: true
  #FIXME_AB: since you have put a validation here, its good idea to have same constrant on db
  validates :description, length: { maximum: 250 }
  validate :session_start_date_should_be_between_event_range
  validate :session_end_date_should_be_between_event_range


  #FIXME_AB: rename both of these methods and can be merged
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
