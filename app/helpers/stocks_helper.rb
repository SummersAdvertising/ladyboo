#encoding: utf-8
module StocksHelper
  
  def show_stocks(stocks)
    # if(stocks.length > 1)
    #   select_tag( "cart[stock]", generate_stock_options(stocks) )
    # else
      hidden_field_tag( "cart[stock]", stocks.first.id )
    # end
  end

  #not in use
  def generate_stock_options(stocks)
    @stock_options = String.new

    stocks.each do |stock|
      stock_name = stock.assign_amount ? "#{stock.name}：#{stock.amount}" : stock.name
      @stock_options += "<option value='#{stock.id}'>#{ stock_name }</option>"
    end

    return @stock_options.html_safe
  end

  def show_stock_amount(stock)
    if(stock.assign_amount)
      return " / 庫存數量：#{stock.amount}"
    end    
  end

  def show_stock_amount_options(stock, amount_in_cart)
    @stock_options = String.new

    if stock.assign_amount == true #追蹤庫存類產品
      if stock.amount - amount_in_cart >= 10
        #MAX TO 10
        i = 1
        loop do
          @stock_options += "<option value='#{i}'>#{ i }</option>"
          i += 1
          break if i > 10
        end
      else stock.amount - amount_in_cart >= 1
        #ACTUAL STOCK
        i = 1
        loop do
          @stock_options += "<option value='#{i}'>#{ i }</option>"
          i += 1
          break if i > stock.amount - amount_in_cart
        end
      end
    else #不追蹤庫存類產品
      i = 1
      loop do
        @stock_options += "<option value='#{i}'>#{ i }</option>"
        i += 1
        break if i > 10
      end
    end

    return @stock_options.html_safe
  end

end