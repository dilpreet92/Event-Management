class Session < ActiveRecord::Base

  belongs_to :event

  has_many :rsvps, dependent: :destroy
  has_many :attendes, through: :rsvps, source: :user

  validates :topic, :location, :description, presence: true
  validates :description, length: { maximum: 250 }
  validate :session_start_date
  validate :session_end_date

  def session_start_date
    if start_date < event.start_date || start_date > event.end_date
      errors.add(:start_date, 'Session should be present in the given event interval')
    end
  end

  def session_end_date
    if end_date > event.end_date || end_date < start_date
      errors.add(:end_date, 'Session should be present in the given event interval')
    end
  end

end
