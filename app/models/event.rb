class Event < ActiveRecord::Base

  belongs_to :user

  has_many :sessions, dependent: :restrict_with_exception

  validates :name, :address, :city, :country, :contact_number, :description, presence: true
  validates :description, length: { maximum: 500 }
  validates :contact_number, numericality: { only_integer: true }
  validate :validate_date

  scope :enabled, -> { where(enable: true) }
  scope :order_by, -> (sort){ order(start_date: sort) }
  scope :upcoming, -> { where("end_date >= ?", Time.current) }
  scope :past, -> { where("end_date < ?", Time.current) }
  scope :search, ->(event) { where("name LIKE :event OR city LIKE :event OR country LIKE :event",
                            event: "%#{ event }%") }

  def validate_date
    if start_date < Time.current || start_date >= end_date
      errors.add(:start_date, ' Should be less than end date and Should be a future date')
    end
  end

  def get_attendes
    sessions.collect do |session|
      session.attendes
    end.flatten.uniq
  end

  def upcoming?
    Event.upcoming.include?(self)
  end

end
