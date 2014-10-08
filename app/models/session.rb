class Session < ActiveRecord::Base

  belongs_to :event

  has_many :rsvps
  has_many :attendes, through: :rsvps, source: :user

  validates :topic, :location, :description, presence: true
  validates :description, length: { maximum: 250 }
  validate :validate_session_start_date
  validate :validate_session_end_date

  def validate_session_start_date
    if start_date < event.start_date || start_date > event.end_date
      errors.add(:start_date, 'Session should be present in the given event interval')
    end
  end

  def validate_session_end_date
    if end_date > event.end_date || end_date < start_date
      errors.add(:end_date, 'Session should be present in the given event interval')
    end
  end

end
