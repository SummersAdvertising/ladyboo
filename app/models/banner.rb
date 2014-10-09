#encoding: utf-8
class Banner < ActiveRecord::Base
  has_many :galleries, -> { order('ranking, created_at') } , as: :attachable , dependent: :destroy

  before_validation :check_attrs
  validates_presence_of :description

  scope :front, -> { where(status: "enable").order('ranking ASC, created_at DESC') }  
  scope :for_admin, -> { order('ranking ASC, created_at DESC') }  

  def check_attrs
    self.title = "未命名 Banner" if self.title.blank?
    self.description = " " if self.description.blank?
    self.status = "enable"
    self.description = "javascript:void(0);" if self.description.blank?
  end

  def get_status
    case self.status
    when "disable"
      "下架"
    when "enable"
      "上架"
    end   
  end

  def is_available?
    self.status == "enable" ? true : false
  end

end
