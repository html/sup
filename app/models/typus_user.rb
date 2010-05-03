class TypusUser < ActiveRecord::Base
  validates_presence_of :login
  validates_uniqueness_of :login
  has_many :events, :foreign_key => :owner_id

  ROLE = Typus::Configuration.roles.keys.sort
  LANGUAGE = Typus.locales

  enable_as_typus_user

  def self.authenticate_by_login_and_password(login, password)
    user = find_by_login(login)
    user && user.authenticated?(password) ? user : nil
  end
end
