class Session < ActiveRecord::Base

  belongs_to :event

  has_many :rsvps, dependent: :destroy
  has_many :attendes, through: :rsvps, source: :user

  #FIXED: add validation for event. validate :event, :presence true
  validates :event_id, presence: true
  validates :topic, :location, :description, presence: true
  validates :description, length: { maximum: 250 }
  validate :session_start_date
  validate :session_end_date

  def session_start_date
    if start_date_unacceptable?
      errors.add(:start_date, show_error_message)
    end
  end

  def session_end_date
    if end_date_unacceptable?
      #FIXED: since you have event start and end date, you can add them to the error message for user.
      errors.add(:end_date, show_error_message)
    end
  end
  
  private

    def start_date_unacceptable?
      start_date < event.start_date || start_date > event.end_date
    end

    def end_date_unacceptable?
      end_date > event.end_date || end_date < start_date
    end

    def show_error_message
      "Session should be present between #{ event.start_date } and #{ event.end_date }"
    end

end
