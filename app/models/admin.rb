class Admin < ActiveRecord::Base
#FIXED: no validation?
  devise :database_authenticatable
  validates :username, :password, presence: true
  validates :username, uniqueness: true
  validates :password, :format => { :with => /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,}$\z/, 
    message: "must be at least 8 characters and include one number and one lowercase and one uppercase."}

end
