# encoding: utf-8
class Contact < ActiveRecord::Base

  validates_presence_of :name, :message => "姓名不能為空白"
  validates_presence_of :subject, :message => "主旨不能為空白"
  validates_presence_of :content, :message => "留言不能為空白"
  
  validates :email, :format => { :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :message => 'E-Mail 格式不符'  }
  #validates_presence_of :phone, :message => "請輸入電話或行動電話"
  #validates :phone, :format => { :with =>/[- #)(0-9]{4,10}[- #)(0-9]{4,10}/, :message => '聯絡電話 格式不符' }

  #validates :phone, :format => { :with => /\(?([0-9]{3})\)?([ #-]?)([0-9]{3,4})\2([0-9]{4})/, :message => '聯絡電話 格式不符' }
  
  paginates_per 25

end
