#encoding: utf-8
class Community < ActiveRecord::Base
  belongs_to :article, :dependent => :destroy
  has_many :galleries, -> { order('ranking, created_at') } , as: :attachable , dependent: :destroy

  scope :for_index, -> { where(status: "enable").order('ranking ASC, created_at DESC') }  
  scope :for_admin, -> { order('ranking ASC, created_at DESC') }  

  validates_presence_of :title
  
  before_validation :check_attrs
  
  paginates_per 5
    
  def check_attrs
    self.title = "未命名文章" if self.title.blank?
    self.status = "enable" if self.status.blank?
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

class PeditorCommunity < Community
  
end

class CustomizedCommunity < Community
  
end