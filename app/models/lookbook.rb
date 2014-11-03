#encoding: utf-8
class Lookbook < ActiveRecord::Base
  has_many :lookbook_topicships, dependent: :destroy
  has_many :topics , through: :lookbook_topicships
  
  has_many :galleries, -> { order('ranking, created_at') } , as: :attachable , dependent: :destroy
  has_many :tiles, -> { order('ranking, created_at') }
  
  has_many :products, through: :topics

  validates_presence_of :name
  validates :limit, numericality: { greater_than_or_equal_to: 1 }
end
