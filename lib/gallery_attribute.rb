#encoding: utf-8
module GalleryAttribute
  extend ActiveSupport::Concern
  included do
    has_many :galleries, -> { order('ranking, created_at') } , as: :attachable , dependent: :destroy
  end
end