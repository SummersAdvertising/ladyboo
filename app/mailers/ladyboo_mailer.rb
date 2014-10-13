class LadybooMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def atm_checkout_completed_successfully(order)
    
    # origin
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      @ordersum = sum_order_items(order.orderitems) + get_shipping_fee_from_order(order)
      
      mail(:to => [ order.user.email ], :subject => "Ladyboo網站 訂購單(#{order.ordernum})")
    end
    
  end

  def vaccount_checkout_completed_successfully(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      @payment_window = 3 #繳款期限
      mail(:to => [ order.user.email ], :subject => "Ladyboo網站 訂購單(#{order.ordernum})")
    end
  end

  def cod_checkout_completed_successfully(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      mail(:to => [ order.user.email ], :subject => "Ladyboo網站 訂購單(#{order.ordernum})")
    end
  end

  def general_checkout_completed_successfully(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      mail(:to => [ order.user.email ], :subject => "Ladyboo網站 訂購單(#{order.ordernum})")
    end
  end

  def ship(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      mail(:to => [ order.user.email ], :subject => "Ladyboo網站 出貨通知(#{order.ordernum})")
    end
  end

  def ship_cod(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      mail(:to => [ order.user.email ], :subject => "Ladyboo網站 出貨通知(#{order.ordernum})")
    end
  end

  def cancel_deal(order)
    attachments.inline['maillogo.jpg'] = with_logo_image
    ActiveRecord::Base.connection_pool.with_connection do
      user = order.user.email
      @order = order
      mail(:to => [ order.user.email ], :subject => "Ladyboo網站 訂單取消(#{order.ordernum})")
    end
  end
  # send to user end

  # send to admin
  # 訂單成立
  def order_placed(order)
    ActiveRecord::Base.connection_pool.with_connection do
      @order = order
      unless gather_moderator_mailto_address.length == 0
        mail(:to => gather_moderator_mailto_address, :subject => "Ladyboo網站 新訂單成立(#{order.ordernum})")
        #mail(:to => gather_moderator_mailto_address, bcc: gather_admin_cc_address, :subject => "Ladyboo網站 新訂單成立")
      end
    end
  end

  #已匯後五碼
  def atm_money_placed(order)
    ActiveRecord::Base.connection_pool.with_connection do
      @order = order
      unless gather_moderator_mailto_address.length == 0
        mail(:to => gather_moderator_mailto_address, :subject => "Ladyboo網站 ATM填寫後五碼(#{order.ordernum})")
      end
    end
  end

  #新詢問
  def new_order_ask(order)
    ActiveRecord::Base.connection_pool.with_connection do
      @order = order
      unless gather_moderator_mailto_address.length == 0
        mail(:to => gather_moderator_mailto_address, :subject => "Ladyboo網站 客服信件(#{order.ordernum})")
      end
    end
  end
  # send to admin end
  private

  def gather_moderator_mailto_address
    #Admin.collect{|admin| admin['email']} 
    Admin.pluck(:email)
  end

  # def gather_admin_cc_address
  #   Admin.collect{|admin| admin['email']} 
  # end

end
