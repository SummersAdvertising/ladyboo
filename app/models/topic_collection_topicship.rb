class TopicCollectionTopicship < ActiveRecord::Base
  belongs_to :topic_collection
  belongs_to :topic
  
end
