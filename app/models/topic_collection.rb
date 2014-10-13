#encoding: utf-8
class TopicCollection < ActiveRecord::Base
  has_many :topic_collection_topicships, dependent: :destroy
  has_many :topics , through: :topic_collection_topicships

end
