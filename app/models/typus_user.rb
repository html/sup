class TypusUser < ActiveRecord::Base
  belongs_to :place, :class_name => 'Place'
  validates_presence_of :login
  validates_uniqueness_of :login
  has_many :events, :foreign_key => :owner_id
  has_attached_file :avatar, :default_url => '/images/no_image.jpg', :styles => {
    :default => "150x150#"
  }

  ROLE = Typus::Configuration.roles.keys.sort
  LANGUAGE = Typus.locales

  enable_as_typus_user

  def self.authenticate_by_login_and_password(login, password)
    user = find_by_login(login)
    user && user.authenticated?(password) ? user : nil
  end

  def change_password(data)
    pass = data[:password]
    confirm = data[:password_confirmation]

    self.password = pass
    self.password_confirmation = confirm

    if(!pass || pass.blank?)
      self.errors.add(:password, "не может быть пустым") 
    end

    unless pass == confirm
      self.errors.add(:password, 'не совпадает с подтверждением')
    end

    errors.empty? && save 
  end

  def generate_recovery_hash
    self.update_attributes! :recovery_hash => Digest::MD5.hexdigest("#{Time.now.to_i}--some secret password")
  end

  def full_name
    "#{last_name} #{first_name} #{patronymic}"
  end
end
