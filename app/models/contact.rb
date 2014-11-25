# encoding: utf-8
class Contact < ActiveRecord::Base
  
  require 'sanitize'
  before_validation :sanitize_content, :on => :create

  validates_presence_of :name, :message => "姓名不能為空白"
  validates_presence_of :subject, :message => "主旨不能為空白"
  validates_presence_of :content, :message => "留言不能為空白"
  
  validates :email, :format => { :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :message => 'E-Mail 格式不符'  }
  #validates_presence_of :phone, :message => "請輸入電話或行動電話"
  #validates :phone, :format => { :with =>/[- #)(0-9]{4,10}[- #)(0-9]{4,10}/, :message => '聯絡電話 格式不符' }

  #validates :phone, :format => { :with => /\(?([0-9]{3})\)?([ #-]?)([0-9]{3,4})\2([0-9]{4})/, :message => '聯絡電話 格式不符' }
  scope :new_asks, -> { where(status: 'new').order(created_at: :asc)}
  scope :history_asks, -> { where(status: 'done').order(created_at: :desc) }

  paginates_per 25

  before_validation :check_attrs
  
  private

    def sanitize_content
      self.name = Sanitize.fragment(self.name, Sanitize::Config::DEFAULT)
      self.subject = Sanitize.fragment(self.subject, Sanitize::Config::DEFAULT)
      self.content = Sanitize.fragment(self.content, Sanitize::Config::DEFAULT)
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
