class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates: :user_name, :session_token, uniqueness: true
  validates: :password, length: {minimum: 6, allow_nil: true}
  after_initialize :check_session_token

  attr_reader password

  def check_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def self.reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    bc_obj = BCrypt::Password.new(self.password_digest)
    bc_obj.is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    user && user.is_password?(password) ? user : nil
  end



end
