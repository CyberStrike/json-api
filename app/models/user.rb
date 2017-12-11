class User < ApplicationRecord

  has_secure_password

  has_many :todos

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :password_digest, presence: true

end
