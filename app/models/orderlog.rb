#encoding: utf-8
class Orderlog < ActiveRecord::Base
  belongs_to :order

  # listener
  def pub_atm_checkout_completed_successfully(order)
    generate_orderlog(order)
  end
  
  def pub_vaccount_checkout_completed_successfully(order)
    generate_orderlog(order)
  end
  
  def pub_cod_checkout_completed_successfully(order)
    generate_orderlog(order)
  end
  
  def pub_general_checkout_completed_successfully(order)
    generate_orderlog(order)
  end

  def pub_money_placed_notice(order)
    generate_orderlog(order)
  end

  def pub_pay(order)
    generate_orderlog(order)
  end

  def pub_ship(order)
    generate_orderlog(order)
  end

  def ship_COD(order)
    generate_orderlog(order)
  end

  def pub_finished(order)
    generate_orderlog(order)
  end

  def pub_cancel_deal(order)
    generate_orderlog(order)
  end

  def pub_human_service(order)
    generate_orderlog(order)
  end

  def pub_abnormal_end(order)
    generate_orderlog(order)
  end

  def pub_deal_failed_at_checkout(order) 
    generate_orderlog(order)
  end


  private

  def generate_orderlog(order)
    order.orderlogs.create({ content: "#{order.get_payment_status}" , inner_state: "#{order.aasm_state}" })
  end

end
