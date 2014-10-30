#encoding: utf-8
class LadybooMailer < ActionMailer::Base
  include OrdersHelper
  #require this lib when sending email by MailGun API
  require 'multimap'
  #default from: "Ladyboo <postmaster@sandbox6bfc02b6428d419186e8f7fa102fb7a1.mailgun.org>"
  #default from: "from@example.com"
  
  before_action :set_basic_data
  
  # send to user
  def welcome(user)
    attachments.inline['emaillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do

      @user = user
      # through api: set params
      @data[:to] = [ user.email ]
      @data[:subject] = "LadyBoo 會員註冊通知信" # 主旨
      @data[:html] = render 'welcome' # 內容
      # through api: set params end
      deliver_by_api(@data)
    end
  end

  def atm_checkout_completed_successfully(order)
    
    # origin
    attachments.inline['maillogo.jpg'] = with_logo_image

    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      @ordersum = sum_order_items(order.orderitems) + get_shipping_fee_from_order(order)
        
      # through api: set params
      @data[:to] = [ order.user.email ]
      @data[:subject] = "Ladyboo 訂購單(#{order.ordernum})" # 主旨
      @data[:html] = render 'atm_checkout_completed_successfully' # 內容
      # through api: set params end

      # direct rest post
      deliver_by_api(@data)
      # tradition mailer
      #mail(:to => [ order.user.email ], :subject => "Ladyboo網站 訂購單(#{order.ordernum})")
    end
    
  end

  def vaccount_checkout_completed_successfully(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      @payment_window = 3 #繳款期限
      
      # through api: set params
      @data[:to] = [ order.user.email ]
      @data[:subject] = "Ladyboo 訂購單(#{order.ordernum})" # 主旨
      @data[:html] = render 'vaccount_checkout_completed_successfully' # 內容
      # through api: set params end
      deliver_by_api(@data)

      #mail(:to => [ order.user.email ], :subject => "Ladyboo網站 訂購單(#{order.ordernum})")
    end
  end

  def cod_checkout_completed_successfully(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order

      # through api: set params
      @data[:to] = [ order.user.email ]
      @data[:subject] = "Ladyboo 訂購單(#{order.ordernum})" # 主旨
      @data[:html] = render 'cod_checkout_completed_successfully' # 內容
      # through api: set params end
      deliver_by_api(@data)
      #mail(:to => [ order.user.email ], :subject => "Ladyboo網站 訂購單(#{order.ordernum})")
    end
  end

  def general_checkout_completed_successfully(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order

      # through api: set params
      @data[:to] = [ order.user.email ]
      @data[:subject] = "Ladyboo 訂購單(#{order.ordernum})" # 主旨
      @data[:html] = render 'general_checkout_completed_successfully' # 內容
      # through api: set params end
      deliver_by_api(@data)
      
      #mail(:to => [ order.user.email ], :subject => "Ladyboo網站 訂購單(#{order.ordernum})")
    end
  end

  def ship(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      # through api: set params
      @data[:to] = [ order.user.email ]
      @data[:subject] = "Ladyboo 出貨通知(#{order.ordernum})" # 主旨
      @data[:html] = render 'ship' # 內容
      # through api: set params end
      deliver_by_api(@data) 
      #mail(:to => [ order.user.email ], :subject => "Ladyboo網站 出貨通知(#{order.ordernum})")
    end
  end

  def ship_cod(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      # through api: set params
      @data[:to] = [ order.user.email ]
      @data[:subject] = "Ladyboo 出貨通知(#{order.ordernum})" # 主旨
      @data[:html] = render 'ship_cod' # 內容
      # through api: set params end
      deliver_by_api(@data)
      # mail(:to => [ order.user.email ], :subject => "Ladyboo網站 出貨通知(#{order.ordernum})")
    end
  end

  def cancel_deal(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      # through api: set params
      @data[:to] = [ order.user.email ]
      @data[:subject] = "Ladyboo 訂單取消(#{order.ordernum})" # 主旨
      @data[:html] = render 'cancel_deal' # 內容
      # through api: set params end
      deliver_by_api(@data)
      # mail(:to => [ order.user.email ], :subject => "Ladyboo網站 訂單取消(#{order.ordernum})")
    end
  end
  # send to user end

  # send to admin
  # 訂單成立
  def order_placed(order)
    ActiveRecord::Base.connection_pool.with_connection do
      @order = order
      unless gather_moderator_mailto_address.length == 0
        # through api: set params
        @data[:to] = gather_moderator_mailto_address
        @data[:subject] = "Ladyboo 新訂單成立(#{order.ordernum})" # 主旨
        @data[:html] = render 'order_placed' # 內容
        # through api: set params end
        deliver_by_api(@data)
        # mail(:to => gather_moderator_mailto_address, :subject => "Ladyboo網站 新訂單成立(#{order.ordernum})")
        #mail(:to => gather_moderator_mailto_address, bcc: gather_admin_cc_address, :subject => "Ladyboo網站 新訂單成立")
      end
    end
  end

  #已匯後五碼
  def atm_money_placed(order)
    ActiveRecord::Base.connection_pool.with_connection do
      @order = order
      unless gather_moderator_mailto_address.length == 0
        # through api: set params
        @data[:to] = gather_moderator_mailto_address
        @data[:subject] = "Ladyboo ATM填寫後五碼(#{order.ordernum})" # 主旨
        @data[:html] = render 'atm_money_placed' # 內容
        # through api: set params end
        deliver_by_api(@data)
        # mail(:to => gather_moderator_mailto_address, :subject => "Ladyboo網站 ATM填寫後五碼(#{order.ordernum})")
      end
    end
  end

  # ORDER 新詢問
  def new_order_ask(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      @order = order

      unless gather_moderator_mailto_address.length == 0
        # through api: set params
        @data[:to] = gather_moderator_mailto_address
        @data[:subject] = "Ladyboo 客服信件(#{order.ordernum})" # 主旨
        @data[:html] = render 'new_order_ask' # 內容
        # through api: set params end
        deliver_by_api(@data)
        # mail(:to => gather_moderator_mailto_address, :subject => "Ladyboo網站 客服信件(#{order.ordernum})")
      end
    end
  end

  # 一般 新詢問
  def contact(contact)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      @contact = contact

      unless gather_moderator_mailto_address.length == 0
        # through api: set params
        @data[:to] = gather_moderator_mailto_address
        @data[:subject] = "Ladyboo 訪客留言(#{contact.name})" # 主旨
        @data[:html] = render 'contact' # 內容
        # through api: set params end
        deliver_by_api(@data)
        # mail(:to => gather_moderator_mailto_address, :subject => "Ladyboo網站 客服信件(#{order.ordernum})")
      end
    end
  end
  # send to admin end
  private

  # MAILGUN
  def set_basic_data
    @data = Multimap.new
    @data[:from] = "Ladyboo <no-reply@mg.ladybootw.com>"
    @data[:inline] = File.new(File.join("public","images","email", "maillogo.jpg")) # inline img
  end

  def deliver_by_api(data)
    RestClient.post "https://api:#{ Rails.application.config.action_mailer.mailgun_settings[:api_key]}@api.mailgun.net/v2/#{ Rails.application.config.action_mailer.mailgun_settings[:domain]}/messages", data.to_hash
  end

  def with_logo_image
    File.read(File.join("public","images","email", "maillogo.jpg")) # inline img
  end

  def gather_moderator_mailto_address
    #Admin.collect{|admin| admin['email']} 
    Admin.pluck(:email)
  end

  # def gather_admin_cc_address
  #   Admin.collect{|admin| admin['email']} 
  # end

end
