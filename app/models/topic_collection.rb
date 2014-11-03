#encoding: utf-8
class TopicCollection < ActiveRecord::Base
  has_many :topic_collection_topicships, dependent: :destroy
  has_many :topics , through: :topic_collection_topicships

  has_many :galleries, through: :topics
  has_many :products, through: :topics

  validates_presence_of :name
  validates :limit, numericality: { greater_than_or_equal_to: 1 }
  
end
