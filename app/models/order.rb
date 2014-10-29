#encoding: utf-8
class Order < ActiveRecord::Base
  #resourcify

  include Wisper::Publisher
  
  @@sendmail = true

  belongs_to :user
  has_many :orderitems, :dependent => :destroy
  has_many :orderasks, :dependent => :destroy
  has_many :orderlogs, :dependent => :destroy

  before_validation :check_attrs
  
  #order implements in controller

  scope :todolist, -> { where(aasm_state: ["order_placed_general","order_placed_COD", "money_placed", "money_checked","order_placed_Vaccount"]) }  
  scope :pending, -> { where(aasm_state: ["order_placed_ATM", "order_placed_Vaccount"]) }  
  scope :human_involved, -> { where(aasm_state: ["human_involved"]) }  
  scope :shipped, -> { where(aasm_state: ["shipped", "shipped_COD"]) }  
  scope :history, -> { where(aasm_state: ["close","abnormal","cancel"]) }  
  
  scope :latest, -> { where("aasm_state != 'hold'").order(created_at: :desc) }

  paginates_per 30

  #validation

  validates_presence_of :receiver_name, :receiver_address, :receiver_tel,
    message: "收件人欄位均為必填"

  validates_presence_of :invoice_title, :invoice_companynum, message: "請填寫發票抬頭及統編" , if: "invoice_type == 'three-copies'"
  # validates_presence_of  , if: "invoice_type == 'three-copies'"
  validates_numericality_of :accountinfo , message: "請填寫數字5碼", on: :update, :allow_nil => true , if: "payment_type == 'atm_transfer'"
  validates_length_of :accountinfo, is: 5 , message: "請填寫數字5碼", on: :update , :allow_nil => true, if: "payment_type == 'atm_transfer'"
  validates_length_of :invoice_companynum, is: 8 , message: "請填寫數字8碼", on: :update , if: "invoice_type == 'three-copies'"

  def check_attrs
    self.ordernum = self.generate_ordernum if self.ordernum.blank?
    self.invoice_type = 'two-copies' if self.invoice_type.blank?
    self.payment_status = "hold" if self.payment_status.blank?
    # self.payment_type = "credit_card" if self.payment_type.blank?
    # self.payment_status = "new" if self.payment_type.blank?
  end

  #todo: system column failed like:
  # ship_to
  #

  def generate_ordernum(digits = 11)
   #Date.today.strftime("%Y%m%d").to_s + ("%04d" % (Order.where("created_at >= ?", Time.zone.now.beginning_of_day).count + 1))
   case self.payment_type
      when "atm_transfer"
        type = "AT"
      when "credit_card"
        type = "CR"
      when "COD"
        type = "CD"
      when "Vaccount"
        type = "VA"
      when "paypal"
        type = "PP"
    end
    self.ordernum ||= loop do
     # Make a random number.
     random = "#{type}#{Array.new(digits){rand(10)}.join}"
     # Use the random  number if no other order exists with it.
     if self.class.exists?(ordernum: random)
       # If over half of all possible options are taken add another digit.
       digits += 1 if self.class.count > (10 ** digits / 2)
     else
       break random
     end
    end
  end

  def get_payment_type
    case(self.payment_type)
    when "atm_transfer"
      "ATM"
    when "credit_card"
      "信用卡"
    when "COD"
      "貨到付款"
    when "Vaccount"
      "虛擬帳號"
    when "paypal"
      "Paypal支付"
    end
  end

  def get_delivery_type
    Delivery.find(self.delivery_type).name
  end

  # in users' shoe
  def get_payment_status
    case(self.payment_status)
    when "order_placed_ATM"
      "新訂單"
    when "order_placed_Vaccount"
      "新訂單"
    when "order_placed_COD"
      "新訂單"
    when "order_placed_general"
      "新訂單"
    when "money_placed_notice"
      "待確認付款"
    when "paid"
      "待寄送"
    when "shipped"
      "已出貨"
    when "shipped_COD"
      "已出貨"
    when "finished"
      "交易完成"
    when "human_service"
      "客服處理中"
    when "abnormal_end"
      "交易結束"
    when "cancel"
      "取消訂單"
    when "failed"
      "交易失敗"
    end

  end

  ## HERE to change
  # == checkout successefully
  def atm_checkout_completed_successfully!
    self.update_column(:payment_status, "order_placed_ATM")
    publish(:pub_atm_checkout_completed_successfully, self) # to listener
    LadyboomailerJob.new.async.perform(LadybooMailer, :atm_checkout_completed_successfully, self) if @@sendmail
    LadyboomailerJob.new.async.perform(LadybooMailer, :order_placed, self) if @@sendmail
    #LadybooMailer.atm_checkout_completed_successfully(self).deliver if @@sendmail
    #LadybooMailer.order_placed(self).deliver if @@sendmail
  end
  def vaccount_checkout_completed_successfully!
    self.update_column(:payment_status, "order_placed_Vaccount")
    publish(:pub_vaccount_checkout_completed_successfully, self) # to listener
    LadyboomailerJob.new.async.perform(LadybooMailer, :vaccount_checkout_completed_successfully, self) if @@sendmail
    LadyboomailerJob.new.async.perform(LadybooMailer, :order_placed, self) if @@sendmail
    #LadybooMailer.vaccount_checkout_completed_successfully(self).deliver if @@sendmail
    #LadybooMailer.order_placed(self).deliver if @@sendmail
  end
  def cod_checkout_completed_successfully!
    self.update_column(:payment_status, "order_placed_COD")
    publish(:pub_cod_checkout_completed_successfully, self) # to listener
    LadyboomailerJob.new.async.perform(LadybooMailer, :cod_checkout_completed_successfully, self) if @@sendmail
    LadyboomailerJob.new.async.perform(LadybooMailer, :order_placed, self) if @@sendmail
    # LadybooMailer.cod_checkout_completed_successfully(self).deliver if @@sendmail
    # LadybooMailer.order_placed(self).deliver if @@sendmail
  end
  def general_checkout_completed_successfully!
    #self.update_column(:payment_status, "order_placed_general")
    self.update(:payment_status => "order_placed_general", :paid => "yes")
    publish(:pub_general_checkout_completed_successfully, self) # to listener
    LadyboomailerJob.new.async.perform(LadybooMailer, :general_checkout_completed_successfully, self) if @@sendmail
    LadyboomailerJob.new.async.perform(LadybooMailer, :order_placed, self) if @@sendmail
    # LadybooMailer.general_checkout_completed_successfully(self).deliver if @@sendmail
    # LadybooMailer.order_placed(self).deliver if @@sendmail
  end

  def money_placed_notice!
    self.update_column(:payment_status, "money_placed_notice")
    publish(:pub_money_placed_notice, self) # to listener
    LadyboomailerJob.new.async.perform(LadybooMailer, :atm_money_placed, self) if @@sendmail
    #LadybooMailer.atm_money_placed(self).deliver if @@sendmail
  end
  def pay!
    self.update({ :payment_status => "paid", :paid => "yes"})
    publish(:pub_pay, self) # to listener
  end
  def ship!
    self.update({payment_status: "shipped", paid: "yes", shipped: "yes"})
    publish(:pub_ship, self) # to listener
    LadyboomailerJob.new.async.perform(LadybooMailer, :ship, self) if @@sendmail
    #LadybooMailer.ship(self).deliver if @@sendmail
  end
  def ship_COD!
    self.update({payment_status: "shipped_COD", shipped: "yes"})
    publish(:pub_ship_COD, self) # to listener
    LadyboomailerJob.new.async.perform(LadybooMailer, :ship_cod, self) if @@sendmail
    #LadybooMailer.ship_cod(self).deliver if @@sendmail
  end
  def finished!
    self.update_column(:payment_status, "finished")
    publish(:pub_finished, self) # to listener
  end
  def cancel_deal!
    self.update_column(:payment_status, "cancel")
    publish(:pub_cancel_deal, self) # to listener
    LadyboomailerJob.new.async.perform(LadybooMailer, :cancel_deal, self) if @@sendmail
    #LadybooMailer.cancel_deal(self).deliver if @@sendmail
  end
  def deal_failed_at_checkout!
    self.update_column(:payment_status, "failed")
    publish(:pub_deal_failed_at_checkout, self) # to listener
    
  end
  def human_service!
    self.update_column(:payment_status, "human_service")
    publish(:pub_human_service, self) # to listener
  end
  def abnormal_end!
    self.update_column(:payment_status, "abnormal_end")
    publish(:pub_abnormal_end, self) # to listener
  end

  # real inner state
  include AASM

  aasm do
    
    state :hold, :initial => true # ALL
    
    state :new
    # event :new_order_confirmed do
    #   transitions :from => :hold, :to => :new
    # end
    
    state :cancel , :after_commit => :cancel_deal!# ALL
    state :failed_at_checkout, :after_commit => :deal_failed_at_checkout!# ALL
    event :checkout_failed do
      transitions :from => :hold, :to => :failed_at_checkout
    end

    #ATM
    state :order_placed_ATM,
          :after_commit => :atm_checkout_completed_successfully!
    
    event :checkout_succeeded_ATM do 
      transitions :from => :hold, :to => :order_placed_ATM
    end
    event :cancel_before_paid_ATM do
      transitions :from => :order_placed_ATM, :to => :cancel
    end
    event :atm_transfered do # ATM only
      transitions :from => :order_placed_ATM, :to => :money_placed
    end

    state :money_placed ,
          :after_commit => :money_placed_notice!# ATM only

    event :atm_comfirmed do
      transitions :from => :money_placed, :to => :money_checked
    end        
    #ATM END

    #Vaccount
    state :order_placed_Vaccount,
          :after_commit => :vaccount_checkout_completed_successfully!

    event :checkout_succeeded_Vaccount do 
      transitions :from => :hold, 
                  :to => :order_placed_Vaccount
    end
    event :comfirmed_Vaccount do # VAccount only
      transitions :from => :order_placed_Vaccount, 
                  :to => :money_checked
    end
    event :cancel_before_paid_Vaccount do
      transitions :from => :order_placed_Vaccount, 
                  :to => :cancel
    end
    #Vaccount END

    # COD
    state :order_placed_COD,
          :after_commit => :cod_checkout_completed_successfully!

    event :checkout_succeeded_COD do 
      transitions :from => :hold, 
                  :to => :order_placed_COD
    end
    event :shipping_COD do 
      transitions :from => :order_placed_COD, 
                  :to => :shipped_COD
    end    
    state :shipped_COD,
          :after_commit => :ship_COD!

    event :post_collect_checked do
      transitions :from => :shipped_COD, 
                  :to => :shipped
    end
    event :human_involving_after_order_placed_COD do 
      transitions :from => :order_placed_COD, 
                  :to => :human_involved
    end   
    event :human_involving_post_collect_COD do 
      transitions :from => :shipped_COD, 
                  :to => :human_involved
    end   
    # COD END

    # credit card, 3rd (real time payment)
    # 所有一進來就要出貨的方式
    state :order_placed_general , 
          :after_commit => :general_checkout_completed_successfully!

    event :checkout_succeeded_general do
      transitions :from => :hold, 
                  :to => :order_placed_general
    end
    event :shipping_first do # credit card, 3rd 
      transitions :from => :order_placed_general, 
                  :to => :shipped
    end
    event :human_involving_after_order_placed_general do # credit card, 3rd
      transitions :from => :order_placed_general, 
                  :to => :human_involved
    end   

    # CONCERN
    state :money_checked , 
          :after_commit => :pay!# ATM and VAccount

    event :shipping do
      transitions :from => :money_checked, 
                  :to => :shipped
    end   

    state :shipped , 
          :after_commit => :ship!  

    event :human_involving_after_money_placed do # ATM
      transitions :from => :money_placed, 
                  :to => :human_involved
    end      
    event :human_involving_after_money_checked do # ATM or VAccount
      transitions :from => :money_checked, 
                  :to => :human_involved
    end      
    event :human_involving_after_shipped do # credit card, 3rd
      transitions :from => :shipped, 
                  :to => :human_involved
    end              
    event :human_involved_edit do
      transitions :from => :human_involved, 
                  :to => :human_involved
    end        
    
    state :close , 
          :after_commit => :finished!

    event :close_deal do
      transitions :from => :shipped, :to => :close
    end        

    state :human_involved, 
          :after_commit => :human_service!  
    
    state :abnormal , 
          :after_commit => :abnormal_end!

    event :to_abnormal do
      transitions :from => :human_involved, 
                  :to => :abnormal
    end    
    # CONCERN END

  end
  # AASM END

  #whenever
  def self.delete_hold_orders(range=30.minutes.ago)
    if Order.where(aasm_state: 'hold').where("created_at <= ?", range).count > 0
      logger.info "Processing: Delete abandon orders..." 
      #logger.info Order.where(aasm_state: 'hold').where("created_at <= ?", range).to_json
      # write to another table?
      Order.where(aasm_state: 'hold').where("created_at <= ?", range).destroy_all
      
    else
      logger.info "Processing: No abandon orders this time..." 
    end
  end

end
