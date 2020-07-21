class Sighting < ApplicationRecord
  has_one_attached :image
  

  validates :image, attached: false, content_type: ['image/png', 'image/jpg', 'image/jpeg']

  belongs_to :user
  belongs_to :flower

  has_many :likes, dependent: :destroy
end
