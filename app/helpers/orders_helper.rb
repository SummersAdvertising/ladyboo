#encoding: utf-8
module OrdersHelper
  def sum_order_items(order_items)
    return order_items.inject(0) { | sum, i | sum += i.item_price * i.amount }
  end

  # not in use
  def get_shipping_fee_by_type(order)
    #use in checkout process, should return fee by delivert type
    if order.delivery_type.nil?
      return 120
    else
      return Delivery.find(order.delivery_type).normal_fee
    end

  end

  def get_shipping_fee_from_order(order)
    return order.shipping_fee
  end
  
    # event :checkout_failed do
    # event :checkout_succeeded_ATM do 
    # event :cancel_before_paid_ATM do
    # event :atm_transfered do # ATM only
    # event :atm_comfirmed do
    # event :checkout_succeeded_Vaccount do 
    # event :cancel_before_paid_Vaccount do
    # event :comfirmed_Vaccount do # VAccount only
    # event :checkout_succeeded_general do
    # event :shipping_first do # credit card, 3rd , COD
    # event :human_involving_after_order_placed_general do # credit card, 3rd
    # event :shipping do
    # event :human_involving_after_money_placed do # ATM
    # event :human_involving_after_money_checked do # ATM or VAccount
    # event :human_involving_after_shipped do # credit card, 3rd
    # event :human_involved_edit do
    # event :close_deal do
    # event :to_abnormal do
    # event :checkout_succeeded_COD do
    # event :shipping_COD do 
    # event :post_collect_checked do
    # event :human_involving_after_order_placed_COD do 
  
  def get_event_display_name(event_name)
    case event_name
    when "checkout_failed"
      "使交易失敗"
    when "checkout_succeeded_ATM"
      "使交易成功(ATM)"
    when "cancel_before_paid_ATM"
      "取消"
    when "atm_transfered"
      "已填後五碼"
    when "atm_comfirmed"
      "對賬"
    when "checkout_succeeded_Vaccount"
      "使交易成功(虛擬帳號)"
    when "cancel_before_paid_Vaccount"
      "取消"
    when "comfirmed_Vaccount"
      "對賬"
    when "checkout_succeeded_general"
      "使交易成功(信用卡)"
    when "shipping_first"
      "出貨"
    when "checkout_succeeded_COD"
      "使交易成功(COD)"
    when "shipping_COD"
      "出貨"
    when "post_collect_checked" #貨到付款對賬
      "對賬"
    when "human_involving_after_order_placed_general"
      "人為處理"
    when "human_involving_after_order_placed_COD" #COD
      "人為處理"
    when "human_involving_post_collect_COD" #COD
      "人為處理"
    when "shipping"
      "出貨"
    when "human_involving_after_money_placed"
      "人為處理"
    when "human_involving_after_money_checked"
      "人為處理"
    when "human_involving_after_shipped"
      "人為處理"
    when "human_involved_edit"
      "編輯"
    when "close_deal"
      "完成交易"
    when "to_abnormal"
      "完成"
    else
      "ERR"
    end
  end

  def is_order_paid(order)
    return "<img src='/images/admin/check.png'>".html_safe if order.paid == "yes"
  end

  def is_order_delivered(order)
    return "<img src='/images/admin/check.png'>".html_safe if order.shipped == "yes"
  end

  def ship_to_where(order)
    case order.ship_to
      when 'taiwan'
        "本島"
      when 'island'
        "離島"
    end
  end

  def fetch_tracking_url(order)
    delivery_type = Delivery.find_by_id(order.delivery_type)
    
    if delivery_type
      link_to "進度查詢", delivery_type.tracking_url, target: "_blank"
    else
      "無法產生追蹤聯結"
    end
  end

end