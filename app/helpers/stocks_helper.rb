#encoding: utf-8
module StocksHelper
  
  def check_with_stock(product)
    total_available = 0

    product.stocks.each do | stock |
      if stock.assign_amount
        total_available += stock.amount if stock.amount > 0
      else
        total_available += 1
      end
    end

    total_available > 0 ? true : false

  end 

  def show_stocks(stocks,in_cart, category, product)
    if(stocks.length > 0)
      select_tag( "cart[stock]", generate_stock_options(stocks,in_cart), data: {category: category, product: product} , class: 'form-control')
    else
      hidden_field_tag( "cart[stock]", 0 )
    end
  end

  
  def generate_stock_options(stocks, amount_in_cart)
    @stock_options = String.new
    @stock_options += "<option value=''>- Selecr Size & Color -</option>"
    stocks.each do |stock|
      stock_amount = 0
      if stock.assign_amount == true #追蹤庫存類產品
        if stock.amount - amount_in_cart >= 10
          #MAX TO 10
          stock_amount = '有'
        elsif stock.amount - amount_in_cart >= 1
          #ACTUAL STOCK
          stock_amount = '足夠' #stock.amount - amount_in_cart
        else
          stock_amount = '售完'
        end
      else #不追蹤庫存類產品
        #MAX TO 10
        stock_amount = '有'
      end

      stock_name = stock.assign_amount ? "#{stock.name}/ 庫存：#{stock_amount}" : stock.name
      @stock_options += "<option value='#{stock.id}'>#{ stock_name }</option>"
    end

    return @stock_options.html_safe
  end

  def show_stock_amount(stock)
    if(stock.assign_amount)
      return "#{stock.amount}"
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
      elsif stock.amount - amount_in_cart >= 1
        #ACTUAL STOCK
        i = 1
        loop do
          @stock_options += "<option value='#{i}'>#{ i }</option>"
          i += 1
          break if i > stock.amount - amount_in_cart
        end
      else
        @stock_options = "<option value=''>售完</option>"
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