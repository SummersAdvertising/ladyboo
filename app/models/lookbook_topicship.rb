#encoding: utf-8
class LookbookTopicship < ActiveRecord::Base
  belongs_to :lookbook
  belongs_to :topic
  
end
