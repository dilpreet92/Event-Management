class Event < ActiveRecord::Base

  include Destroyable

  belongs_to :user
  
  has_many :sessions, dependent: :destroy
  has_many :attendes, through: :sessions, source: :attendes
  before_save :ensure_all_sessions_in_range?, message: 'Event cannot be updated'

  #FIXED: you should also read about the patterns we can pass to paperclip styles. like we have > sign in following style, there are much more.
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/index.jpeg"

  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates :name, :address, :city, :country, :contact_number, :description, presence: true
  validates :description, length: { maximum: 500 }
  validate :event_date_valid

  scope :enabled, -> { where(enable: true) }
  scope :order_by_start_date, -> (sort) { order(start_date: sort) }

  scope :live_and_upcoming, -> { where("events.end_date >= ?", Time.current) }
  scope :past, -> { where("events.end_date < ?", Time.current) }

  scope :search, -> (query) { where("lower(events.name) LIKE :query OR lower(events.city) LIKE :query OR 
    lower(events.country) LIKE :query OR lower(sessions.topic) LIKE :query", query: "%#{ query }%") }


  def live_and_upcoming?
    end_date >= Time.current 
  end

  def past?
    end_date <= Time.current
  end

  def owner?(user)
    user_id == user.id
  end

  private

    def event_date_valid
      if start_date_unacceptable?
        errors[:base] << 'Invalid start or end date'
      end
    end
    
    def start_date_unacceptable?
      if new_record?
        (start_date < Time.current) || (start_date >= end_date)
      else
        (start_date < start_date_was) || (start_date >= end_date)
      end 
    end

    def ensure_all_sessions_in_range?
      #FIXED: We should extract complex conditions in a private method for better readability
      if sessions.all? { |session| validate_session_dates(session) } 
        true
      else
        errors[:base] << 'Event cannot be updated as event has sessions outside the given interval'
        false
      end        
    end

    def validate_session_dates(session)
      session.start_date >= start_date && session.end_date <= end_date 
    end

end
