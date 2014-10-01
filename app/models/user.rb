class User < ActiveRecord::Base
  include BCrypt
  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, :session_token, uniqueness: true
  after_initialize :ensure_session_token

  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)
    user if user && user.is_password?(password)
  end

  def self.generate_session_token
    SecureRandom.hex(16)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.update!(session_token: session_token)
    #rescue if already used
  end

  def password=(password)
    self.password_digest = Password.create(password)
  end

  def is_password?(password)
    Password.new(password_digest).is_password?(password)
  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
