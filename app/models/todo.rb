class Todo < ApplicationRecord
  has_many :items, dependent: :destroy
  belongs_to :user

  validates :title, presence: true
  validates :user, presence: true
end
