class Event < ActiveRecord::Base
  
  belongs_to :user
  #FIXME_AB: whenever you use has_many always think about dependent option. I would suggest to use :restrict here
  #FIXME_AB: Can we have a better name for this
  has_many :user_session_associations
  #FIXME_AB: attendees 
  has_many :attending_users, through: :user_session_associations, source: :user

  #FIXME_AB: think twice when using dependent :destroy. what would happen to RSVPs if you delete sessions.
  #FIXME_AB: Better to use dependent: :restrict
  has_many :event_sessions, dependent: :destroy
  
  validates :name, :address, :city, :country, :contact_number, :description, presence: true
  validates :description, length: { maximum: 500 }
  validates :contact_number, length: { is: 10 }
  validate :start_date_cannot_be_greater_than_end_date

  #FIXME_AB: I would prefer to rename status to enabled
  scope :enabled, -> { where(status: true) }
  #FIXME_AB: Its a good practice to add a comment. "Upcoming events are events having end date in future"
  scope :upcoming, -> { where("end_date >= ?", Time.current).order(:start_date) }

  scope :past, -> { where("end_date < ?", Time.current).order(start_date: :desc) }

  #FIXME_AB: there is a better way, instead of writing event three times you can just use has format. :event => "%#{event}%" and use :event in place of ?
  scope :search, ->(event) { where("name LIKE ? OR city LIKE ? OR country LIKE ?",
                            "%#{ event }%", "%#{ event }%", "%#{ event }%") }


  #FIXME_AB: Method name shoudl be better. How about validate_start_date ?
  def start_date_cannot_be_greater_than_end_date
    if start_date < Time.current
      #FIXME_AB: start date should be a future date
      errors.add(:start_date, 'Start Date should be in present')
    elsif start_date >= end_date
      #FIXME_AB: ???
      errors.add(:end_date, 'Start Date should be greater than End Date')
    end


    #FIXME_AB: I think you can simply check start_date > Time.current && start_date < end_date in single condition and display same message "Start date should be less than end date and shoudl be a future date"

  end

end
