class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, :session_token, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  after_initialize :check_session_token

  attr_reader :password

  def check_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end

  def is_password?(password)
    bc_obj = BCrypt::Password.new(self.password_digest)
    bc_obj.is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user && user.is_password?(password) ? user : nil
  end

  has_many :cats,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :Cat

end
