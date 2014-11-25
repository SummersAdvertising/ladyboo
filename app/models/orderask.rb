#encoding: utf-8
class Orderask < ActiveRecord::Base
  #resourcify
  require 'sanitize'
  before_validation :sanitize_content, :on => :create

  belongs_to :order

  scope :new_asks, -> { where(status: 'new').order(created_at: :asc)}
  scope :history_asks, -> { where(status: 'done').order(created_at: :desc) }

  paginates_per 10
  
  validates_presence_of :description, message: '請填寫內容'

  before_validation :check_attrs
  #after_create :deliver_notice

  private 

    def sanitize_content
      self.description = Sanitize.fragment(self.description, Sanitize::Config::DEFAULT)
    end
  
    def check_attrs
      self.status = "new" if self.status.blank?
    end

    def get_status
      case self.status
      when "new"
        "未處理"
      when "done"
        "已處理"
      end
    end

end
