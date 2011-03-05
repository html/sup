require 'digest/md5'

class TypusUser < ActiveRecord::Base
  apply_simple_captcha
  belongs_to :place, :class_name => 'Place'
  validates_presence_of :login
  validates_uniqueness_of :login
  has_many :events, :foreign_key => :owner_id
  has_attached_file :avatar, :default_url => '/img/NOAVAT1.png', :styles => {
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

  def self.masters(page = nil)
    paginate_by_role('master', :page => (page || 1), :per_page => 5)
  end

  def activated?
    !activation_code
  end

  def generate_activation_code
    self.activation_code = Digest::MD5.hexdigest([Time.now.to_s, rand(100)].join('-'))
  end

  def make_activated
    self.update_attributes :activation_code => nil
  end

  def email_address_with_name
    "<#{full_name.html_safe!}> #{email}"
  end
end
