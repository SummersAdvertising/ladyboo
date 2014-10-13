#encoding: utf-8
class Lookbook < ActiveRecord::Base
  has_many :lookbook_topicships, dependent: :destroy
  has_many :topics , through: :lookbook_topicships
  
end
