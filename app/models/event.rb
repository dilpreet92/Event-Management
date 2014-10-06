class Event < ActiveRecord::Base
  belongs_to :user
  has_many :user_session_associations
  has_many :attending_users, through: :user_session_associations, source: :user
  has_many :event_sessions, dependent: :destroy
  validates :name, :address, :city, :country, :contact_number, :description, presence: true
  validates :description, length: { maximum: 500 }
  validates :contact_number, length: { is: 10 }
  validate :start_date_cannot_be_greater_than_end_date
  scope :enabled, -> { where(status: true) }
  scope :upcoming, -> { where("end_date >= ?", Time.current).order(:start_date) }
  scope :past, -> { where("end_date < ?", Time.current).order(start_date: :desc) }
  scope :search, ->(event) { where("name LIKE ? OR city LIKE ? OR country LIKE ?",
                            "%#{ event }%", "%#{ event }%", "%#{ event }%") }

  def start_date_cannot_be_greater_than_end_date
    if start_date < Time.current
      errors.add(:start_date, 'Start Date should be in present')
    elsif start_date >= end_date
      errors.add(:end_date, 'Start Date should be greater than End Date')
    end
  end

end
