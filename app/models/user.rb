class User < ActiveRecord::Base
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9][a-zA-Z0-9_-]*\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  USER_REPLY_REGEX = /\A@([a-zA-Z0-9_-]*)/
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :messages, foreign_key: "sender_id", dependent: :destroy
  has_many :received_messages, foreign_key: "receiver_id", class_name: "Message", dependent: :destroy
  before_create :create_remember_token
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :username, presence: true, length: { maximum: 15 }, uniqueness: { case_sensitive: false }, format: { with: VALID_USERNAME_REGEX }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def User.reply_match(content)
    USER_REPLY_REGEX.match(content)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
