class Event < ActiveRecord::Base
  belongs_to :user
  has_many :user_event_associations
  has_many :attending_users, through: :user_event_associations, source: :user
  has_many :event_sessions, dependent: :destroy
  validates :name, :address, :city, :country, :contact_number, :description, presence: true
  validates :description, length: { maximum: 500 }
  validates :contact_number, length: { is: 10 }
  validate :start_date_cannot_be_greater_than_end_date
  validate :start_time_cannot_be_greater_than_end_time

  def start_date_cannot_be_greater_than_end_date
    if start_date < Date.today
      errors.add(:start_date, 'Start Date should be in present')
    elsif start_date > end_date
      errors.add(:end_date, 'Start Date should be greater than or equal to End Date')
    end
  end

  def start_time_cannot_be_greater_than_end_time
    if start_time >= end_time
      errors.add(:end_time, 'Start Time should be greate than End Time')
    elsif start_time >= Time.now
      errors.add(:start_time, 'Events are supposed to be scheduled in future')
    end
  end    

end
