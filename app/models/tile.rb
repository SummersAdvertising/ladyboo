#encoding: utf-8
class Tile < ActiveRecord::Base
  belongs_to :lookbook
  belongs_to :topic
  
  has_many :galleries, -> { order('ranking, created_at') } , as: :attachable , dependent: :destroy

  default_scope -> { order('ranking, created_at') }
  scope :by_lookbook, ->(lookbook_id) { where("lookbook_id = ?", lookbook_id).order('ranking, created_at') }

end
