class User < ApplicationRecord
  validates :user_name, :session_token,
    uniqueness: { message: "must be unique" },
    presence: { message: "must exist" }
  validates :password_digest, presence: { message: "must exist" }
  validates :password, length: { minimum: 6 }

  after_initialize :method_name

  attr_reader :password

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name)
    if user
      user.is_password?(password)
      return user
    end
    nil
  end

  def reset_session_token!
    @session_token = SecureRandom::urlsafe_base64
    save!
    @session_token
  end

  def password=(password)
    @password_digest = BCrypt::Password.create(password)
    save!
    @password_digest
  end

  def is_password?(password)
    BCrypt::Password.new(@password_digest).is_password?(password)
  end


end
