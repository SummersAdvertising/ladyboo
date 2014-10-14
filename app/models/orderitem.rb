class Orderitem < ActiveRecord::Base
  require "cart"
  belongs_to :order

  def self.record_orderitems(order, cookies_cart)
    @order_items = order.orderitems.create( Cart.check_items_in_cart(cookies_cart, "for_order") )

    #substract stock of order items
    #@product_stocks = Stock.assigned_amount.where(:id => @order_items.map{ |item| item.product_stock_id })

    # @product_stocks.each do |stock|
    #   stock.amount -= @order_items.detect{ |item| item.product_stock_id == stock.id }.amount
    #   stock.save

    #   if(stock.amount <= 0)
    #     #mail to admin
    #   end
    # end
  end

  def self.deduct_stock(order) #do this when final comfirm
    @order_items = order.orderitems
    @product_stocks = Stock.assigned_amount.where(:id => @order_items.map{ |item| item.product_stock_id })

    @product_stocks.each do |stock|
      itemstock = @order_items.detect{ |item| item.product_stock_id == stock.id }
      itemstock.lock!

      
      stock.amount -= itemstock.amount 
      stock.save!

      # if stock.amount < 0
      #   raise ActiveRecord::Rollback, "Call tech support!"
      # end

      if(stock.amount <= 0)
        #mail to admin
      end
    end
  end

  def self.rollback_stock(order) #do this when realtime payment failed
    @order_items = order.orderitems
    @product_stocks = Stock.assigned_amount.where(:id => @order_items.map{ |item| item.stock_id })

    @product_stocks.each do |stock|
      stock.amount += @order_items.detect{ |item| item.stock_id == stock.id }.amount
      stock.save

      if(stock.amount <= 0)
        #mail to admin
      end
    end
  end

end
