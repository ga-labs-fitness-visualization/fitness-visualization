class User < ActiveRecord::Base

	has_many :daily_activities

  has_secure_password

  def self.find_by_credentials(args = {})
    user = User.find_by(email: args[:email])
    return nil unless user
    if user.is_password?(args[:password])
      return user
    else
      return nil
    end
  end

  def is_password?(pwd)
    correct_password = BCrypt::Password.new(self.password_digest)
    return correct_password.is_password?(pwd)
  end

end
