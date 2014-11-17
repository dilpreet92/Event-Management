class Event < ActiveRecord::Base

  include Destroyable
  self.skip_time_zone_conversion_for_attributes = [:start_date, :end_date]

  belongs_to :user
  has_many :sessions
  has_many :attendes, -> { where('sessions.enable = true').distinct }, through: :sessions, source: :attendes
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/rails.jpeg"
  
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates :name, :address, :city, :country, :contact_number, :description, :user, :start_date, :end_date, presence: true
  validates :description, length: { maximum: 500 }

  scope :enabled, -> { where('events.enable = true').eager_load(:user).where('users.enabled = true') }
  scope :order_by_start_date, -> (sort) { order(start_date: sort) }
  scope :live_or_upcoming, -> { where("events.end_date >= ?", Time.current).order_by_start_date(:asc) }
  scope :past, -> { where("events.end_date < ?", Time.current).order_by_start_date(:desc) }
  scope :search, -> (query) { where("lower(events.name) LIKE :query OR lower(events.city) LIKE :query OR 
                              lower(events.country) LIKE :country OR lower(sessions.topic) LIKE :query", 
                              query: "%#{ query }%", :country => get_country_name(query) ).distinct }
  
  before_save :valid_event_date?
  before_save :check_all_sessions_in_range?
  
  def live_or_upcoming?
    end_date.utc >= Time.current 
  end

  def self.get_country_name(query)
    "%#{ Carmen::Country.named(query).code.downcase }%" if Carmen::Country.named(query)
  end

  def past?
    end_date.utc <= Time.current
  end

  def owner?(user)
    user_id == user.id
  end

  private

    def valid_event_date?
      if start_date_unacceptable?
        errors[:base] << 'Invalid start or end date'
        false
      end
    end
    
    def start_date_unacceptable?
      if new_record?
        (start_date.utc < Time.current) || (start_date >= end_date)
      else
        (start_date < start_date_was) || (start_date >= end_date)
      end 
    end

    def check_all_sessions_in_range?
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
