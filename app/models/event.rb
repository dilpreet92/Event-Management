class Event < ActiveRecord::Base
  belongs_to :user
  
  has_many :sessions, dependent: :destroy
  has_many :attendes, through: :sessions, source: :attendes
  before_save :check_if_any_session_outside_event_range?, message: 'Event cannot be updated'

  #FIXME_AB: you should also read about the patterns we can pass to paperclip styles. like we have > sign in following style, there are much more.
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/index.jpeg"

  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates :name, :address, :city, :country, :contact_number, :description, presence: true
  validates_length_of :description, maximum: 500
  validate :event_date_valid

  scope :enabled, -> { where(enable: true) }
  scope :order_by_start_date, -> (sort) { order(start_date: sort) }

  scope :live_and_upcoming, -> { where("events.end_date >= ?", Time.current) }
  scope :past, -> { where("events.end_date < ?", Time.current) }

  scope :search, -> (query) { where("events.name ILIKE :query OR events.city ILIKE :query OR 
    events.country ILIKE :query OR sessions.topic ILIKE :query", query: "%#{ query }%") }


  def live_and_upcoming?
    end_date >= Time.current 
  end

  def past?
    end_date <= Time.current
  end

  def owner?(user)
    user_id == user.id
  end

  def to_param
    "#{id}-#{name}"
  end

  private
    def event_date_valid
      if start_date_unacceptable?
        errors.add(:start_date, ' Should be less than end date and Should be a future date')
      end
    end
    
    def start_date_unacceptable?
      (start_date < Time.current) || (start_date >= end_date)
    end

    def check_if_any_session_outside_event_range?
      if sessions.all? { |session| session.start_date >= start_date && session.end_date <= end_date } 
        true
      else
        errors.add(:start_date, 'Event cannot be updated')
        false
      end        
    end

end
