#encoding: utf-8
module CartHelper
  require 'cart'

  def products_in_cart_count
    @cart_items = JSON.parse_if_json(cookies[:cart_ladyboo]) || Hash.new
    cookies[:cart_ladyboo] = Cart.check_cookies(@cart_items)

    return @cart_items.inject(0) { | sum, i | sum += i[1] }
  end

  def sum_cart_items(order_items)
    return order_items.inject(0) { | sum, i | sum += ( i[:price_for_sale] > 0 ? i[:price_for_sale] : i[:price] ) * i[:amount] }
  end

  def no_order_items_msg(count)
    if(count == 0)
      '<tr><td align="center" colspan="9">購物車內沒有商品</td></tr>'.html_safe
    end
  end

  def is_delivery_discounted?(order, sum)

    if sum > Delivery.find(order.delivery_type).discount_criteria
      true
    else
      false
    end

  end

  def fetch_discount_price_when_checkout(delivery_type)
    current_delivery = Delivery.find(delivery_type)

    return current_delivery.normal_fee - current_delivery.discount_fee
  end

  def name_of_invoice(invoice_type)
    if invoice_type == 'two-copies'
      "二聯式發票"
    else
      "三聯式發票"
    end
  end

end