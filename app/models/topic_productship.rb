#encoding: utf-8
class TopicProductship < ActiveRecord::Base
  belongs_to :topic
  belongs_to :product
end
