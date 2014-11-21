class Session < ActiveRecord::Base

  include Destroyable
  self.skip_time_zone_conversion_for_attributes = [:start_date, :end_date]

  belongs_to :event
  has_many :rsvps
  has_many :speakers
  has_many :attendes, through: :rsvps, source: :user
  accepts_nested_attributes_for :speakers, :allow_destroy => true

  validates :topic, :location, :description, :event, :start_date, :end_date, presence: true
  validates :description, length: { maximum: 250 }

  scope :enabled, -> { where(enable: true) }

  before_save :validate_session_start_date, :validate_session_end_date

  def upcoming?
    end_date.utc >= Time.current
  end
  
  private

    def validate_session_start_date
      if start_date_unacceptable?
        errors.add(:start_date, dates_error_message)
        false
      end
    end

    def validate_session_end_date
      if end_date_unacceptable?
        errors.add(:end_date, dates_error_message)
        false
      end
    end

    def start_date_unacceptable?
      start_date < event.start_date || start_date > event.end_date || end_date.day != start_date.day
    end

    def end_date_unacceptable?
      end_date > event.end_date || end_date < start_date
    end

    def dates_error_message
      "Session should be present between #{ event.start_date } and #{ event.end_date } 
        and session cannot be of more than one day"
    end

end
