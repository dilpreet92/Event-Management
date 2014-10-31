class Admin < ActiveRecord::Base
#FIXME_AB: no validation?
  devise :database_authenticatable
  validates :username, :password, presence: true

end
