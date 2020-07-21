class Sighting < ApplicationRecord
  has_one_attached :image
  

  validates :image, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']

  belongs_to :user
  belongs_to :flower

  has_many :likes
end
