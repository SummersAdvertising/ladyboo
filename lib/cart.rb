#encoding: utf-8
class Cart
  ##application layout cart count, in carthelper
  def self.check_cookies(cart_items)
    cart_items.each do | key, num |
      @stock = ProductStock.includes(:product).find_by_id(key)
      cart_items.delete(key) unless(@stock && @stock.product.is_available?)
    end

    cart_items.to_json
  end

  def self.check_stock_all(cookies_cart,cookies_cafe_attr)
    @cart_items = JSON.parse_if_json(cookies_cart) || Hash.new
    @cart_cafe_attrs = JSON.parse_if_json(cookies_cafe_attr) || Hash.new
    #
    #@amount_in_need = (@cart_items[stock.id.to_s] || 0)
    @cart_message = String.new
    @stocks = ProductStock.includes(:product).where(:id => @cart_items.keys)
    @stocks.each do |stock|
      if(stock.assign_amount)
        if(stock.amount >= @cart_items[stock.id.to_s].to_i)
          #@product_amount = { :amount => @cart_items[stock.id.to_s].to_i }
        else
          #@product_amount = { :amount => stock.amount.to_i }
          # @cart_items[stock.id.to_s] = stock.amount.to_i
          #=============
          # if(@cart_items[stock_id].to_i >= 1)
            

          #   if @cart_cafe_attrs[attr_index]["amount"].to_i <= 1
            
          #     @cart_cafe_attrs.delete(attr_index)

          #   else
          #     @cart_cafe_attrs[attr_index]["amount"] = (@cart_cafe_attrs[attr_index]["amount"].to_i - 1)
          #   end

          # else
            # if 該商品庫存不足 則刪除 cart內此商品
            @cart_items.delete(stock.id.to_s)
            @cart_cafe_attrs.each do | attr |
              @cart_cafe_attrs.delete(attr[0]) if attr[1]["stock_id"] == stock.id.to_i
            end
            @cart_message = "部分商品庫存不足 請重新確認數量後再行下單！"
          #end
          #=============
          
          #stock.amount < required amount
          # @cart_cafe_attrs.each do | attr |
          #   if attr[1]["stock_id"] == stock.id.to_i && attr[1]["amount"].to_i >= @cart_items[stock.id.to_s].to_i
          #   else
          #   end
          #   @cart_cafe_attrs.delete(attr[0]) if attr[1]["stock_id"] == stock.id.to_i && attr[1]["amount"].to_i >= @cart_items[stock.id.to_s].to_i
          # end


          #@cart_message += stock.product.name + "," ||= stock.product.name + ","
        end
      else
        #不追蹤庫存的產品
        #should delete all?
        #@product_amount = { :amount => @cart_items[stock.id.to_s].to_i }
        # if 該商品庫存不足 則刪除 cart內此商品
        # @cart_items.delete(stock.id)
        # @cart_cafe_attrs.each do | attr |
        #   @cart_cafe_attrs.delete(attr[0]) if attr[1]["stock_id"] == stock.id.to_i
        # end
        # @cart_message = "部分商品庫存不足！"
      end
    end

    #@cart_message += "庫存不足." unless @cart_message.nil? || @cart_message.empty?

    # if(stock.assign_amount && (stock.amount < @amount_in_need))
    #   @cart_message = "放入購物車的商品數量超過商品庫存！"
    # else
    #   @cart_items[stock.id.to_s] = @amount_in_need

    #   ####################################################HERE
      
    #   @cart_cafe_attrs[Time.now.strftime("%dT%H%M%N")] = (other_attributes)

    #   @cart_message = "已新增至購物車"
    # end

    return { cart_items: @cart_items.to_json, cart_message: @cart_message, cart_cafe_attrs: @cart_cafe_attrs.to_json }
  end

  def self.check_stock(cookies_cart, stock, ask_amount,cookies_cafe_attr, other_attributes)
    @cart_items = JSON.parse_if_json(cookies_cart) || Hash.new
    #
    @cart_cafe_attrs = JSON.parse_if_json(cookies_cafe_attr) || Hash.new
    #
    @amount_in_need = (@cart_items[stock.id.to_s] || 0) + ask_amount

    if(stock.assign_amount && (stock.amount < @amount_in_need))
      @cart_message = "放入購物車的商品數量超過商品庫存！"
    else
      @cart_items[stock.id.to_s] = @amount_in_need

      ####################################################HERE
      
      @cart_cafe_attrs[Time.now.strftime("%dT%H%M%N")] = (other_attributes)

      @cart_message = "已新增至購物車"
    end

    return { cart_items: @cart_items.to_json, cart_message: @cart_message, cart_cafe_attrs: @cart_cafe_attrs.to_json }
  end

  def self.check_items_in_cart(cookies_cart, for_cart_or_order)
    @cart_items = JSON.parse_if_json(cookies_cart) || Hash.new

    @stocks = ProductStock.includes(:product).where(:id => @cart_items.keys)

    @order_items = Array.new

    @stocks.each do |stock|
      @product_amount = { :amount => @cart_items[stock.id.to_s].to_i }
      # if(stock.assign_amount)
      #   if(stock.amount > @cart_items[stock.id.to_s].to_i)
      #     @product_amount = { :amount => @cart_items[stock.id.to_s].to_i }
      #   else
      #     @product_amount = { :amount => stock.amount.to_i }
      #   end
      # else
      #   @product_amount = { :amount => @cart_items[stock.id.to_s].to_i }
      # end

      case for_cart_or_order
      when "for_cart"
        @product_attrs = { 
          :id => stock.id, 
          :name => stock.product.name, 
          :stock_name => stock.name, 
          :image => nil, 
          :price => stock.product.price.to_i, 
          :price_for_sale => stock.product.price_for_sale.to_i ,
          :product_id => stock.product.id.to_s
        }
      when "for_order"
        @product_attrs = { 
          :product_stock_id => stock.id, 
          :item_name => stock.product.name, 
          :item_stockname => stock.name, 
          :item_price => 
          (stock.product.price_for_sale > 0) ? stock.product.price_for_sale.to_i : stock.product.price.to_i
        }
      end

      @order_items.push( @product_attrs.merge(@product_amount) )
    end

    return @order_items
  end

  def self.plus_stock(cookies_cart, stock_id, cookies_cafe_attr, attr_index)
    @cart_items = JSON.parse_if_json(cookies_cart) || Hash.new
    @cart_cafe_attrs = JSON.parse_if_json(cookies_cafe_attr) || Hash.new
    @stock = ProductStock.find_by_id(stock_id)
    @cart_message = String.new

    if(!@stock.assign_amount || @cart_items[stock_id] < @stock.amount)
      @cart_items[stock_id] += 1
      
      #@cart_cafe_attrs.each do | attr |
        #delete all same product
        #@cart_cafe_attrs.delete(attr[0]) if attr[1]["stock_id"] == stock_id
      @cart_cafe_attrs[attr_index]["amount"] = (@cart_cafe_attrs[attr_index]["amount"].to_i + 1)
      #end    

    else
      @cart_message = "放入購物車的商品數量超過商品庫存！"
    end

    return { cart_items: @cart_items.to_json, cart_message: @cart_message, cart_cafe_attrs: @cart_cafe_attrs.to_json }
  end

  def self.minus_stock(cookies_cart, stock_id, cookies_cafe_attr, attr_index)
    @cart_items = JSON.parse_if_json(cookies_cart) || Hash.new
    @cart_cafe_attrs = JSON.parse_if_json(cookies_cafe_attr) || Hash.new

    if(@cart_items[stock_id].to_i > 1)
      @cart_items[stock_id] -= 1

      if @cart_cafe_attrs[attr_index]["amount"].to_i <= 1
      
        @cart_cafe_attrs.delete(attr_index)

      else
        @cart_cafe_attrs[attr_index]["amount"] = (@cart_cafe_attrs[attr_index]["amount"].to_i - 1)
      end

    else

      @cart_items.delete(stock_id)
      @cart_cafe_attrs.delete(attr_index)

    end

    return { cart_items: @cart_items.to_json, cart_message: @cart_message, cart_cafe_attrs: @cart_cafe_attrs.to_json}
  end

  def self.minus_partial_stock_to_zero(cookies_cart, stock_id, cookies_cafe_attr, attr_index)
    @cart_items = JSON.parse_if_json(cookies_cart) || Hash.new
    @cart_cafe_attrs = JSON.parse_if_json(cookies_cafe_attr) || Hash.new

    if(@cart_items[stock_id].to_i > @cart_cafe_attrs[attr_index]["amount"].to_i)
      @cart_items[stock_id] -= @cart_cafe_attrs[attr_index]["amount"].to_i
      @cart_cafe_attrs.delete(attr_index)
    else
      @cart_items.delete(stock_id)
      @cart_cafe_attrs.delete(attr_index)
    end
    
    return { cart_items: @cart_items.to_json, cart_message: @cart_message, cart_cafe_attrs: @cart_cafe_attrs.to_json}
  end

  def self.delete_stock(cookies_cart, stock_id ,cookies_cafe_attr)
    @cart_items = JSON.parse_if_json(cookies_cart) || Hash.new
    @cart_items.delete(stock_id)

    all_intems_in_cart = []
    @cart_items.select{|key,value| all_intems_in_cart << key.to_i}

    @cart_cafe_attrs = JSON.parse_if_json(cookies_cafe_attr) || Hash.new
    
    @cart_cafe_attrs.each do | attr |
      
      @cart_cafe_attrs.delete(attr[0]) if attr[1]["stock_id"] == stock_id.to_i
      @cart_cafe_attrs.delete(attr[0]) unless attr[1]["stock_id"].in? all_intems_in_cart
    end

    return { cart_items: @cart_items.to_json, cart_message: @cart_message , cart_cafe_attrs: @cart_cafe_attrs.to_json }
  end

  private

end