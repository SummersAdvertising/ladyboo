#encoding: utf-8
class Topic < ActiveRecord::Base
  has_many :topic_productships, dependent: :destroy
  has_many :products , through: :topic_productships

  has_many :lookbook_topicships, dependent: :destroy
  has_many :lookbooks , through: :lookbook_topicships

  
end
