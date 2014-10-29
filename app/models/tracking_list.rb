class TrackingList < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  
  has_many :galleries, through: :product
  has_many :categories, through: :product
  has_many :stock, through: :product

  scope :latest, -> { order(updated_at: :desc)}
end
