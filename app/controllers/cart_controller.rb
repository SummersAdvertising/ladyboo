#encoding: utf-8
class CartController < ApplicationController
  require "cart"
  include CartHelper
  include OrdersHelper
  include FocasHelper

  layout "cart"
  
  skip_before_filter :verify_authenticity_token, :only => [:receive_result]

  before_action :record_login_redirect_path, :only => [:check]
  before_action :authenticate_user!, :only => [:check, :create, :post_order, :final_check, :confirm]
  before_action :set_ship_var, :only => [:check]

  after_action :restore_temp_order, :only => [:add, :plus, :minus, :delete, :delete_by_attribute ]
  
  def index

    begin
      @result = Cart.check_stock_all(cookies[:cart_ladyboo])
      cookies[:cart_ladyboo] = { value: @result[:cart_items], httponly: true }

      if @result[:cart_message].to_s.length > 0
        flash.now[:alert] = @result[:cart_message]
      else 
        #flash.now[:notice] = "購物車內沒有商品"
      end

      @order_items = Cart.check_items_in_cart(cookies[:cart_ladyboo], "for_cart")
    rescue
      flash[:notice] = "Oops..."
      reset_everything_about_cart
      redirect_to root_path
    end
  end

  def set_ship_to
    
    @@ship_to = nil
    
    @@ship_to = params[:shipping_to] if params[:shipping_to].in? ["taiwan","island","overseas"]
    
    if @@ship_to.nil? || @@ship_to.empty?
      redirect_to cart_index_path, notice: "請選擇運送區域"
    else
      redirect_to check_cart_index_path  
    end
    
  end

  def check
    begin
      @order = Order.new
      @order_items = Cart.check_items_in_cart(cookies[:cart_ladyboo], "for_cart")
      
      @@ship_to = nil
      
      redirect_to cart_index_path, notice: "請選擇運送區域"  and return if @ship_to.nil? || @ship_to.empty?

      redirect_to cart_index_path, alert: "購物車內沒有商品"  and return if @order_items.length == 0
    rescue
      flash[:notice] = "Oops..."
      reset_everything_about_cart
      redirect_to root_path
    end

  end

  def create
    # begin
      @order = current_user.orders.new(order_params)

      respond_to do |format|
        if(@order.save)
          User.update_info_on_order_create(current_user, params)
          Orderitem.record_orderitems(@order, cookies[:cart_ladyboo])

          order_items = Cart.check_items_in_cart(cookies[:cart_ladyboo], "for_cart")
          cart_sum = sum_cart_items(order_items)

          # ORDER ATTRIBUTES
          @order.update({ delivery_type: recheck_delivery_type(@order), shipping_fee: define_shipping_fee(@order, cart_sum)} )

          crypt = ActiveSupport::MessageEncryptor.new(Ladyboo::Application.config.secret_key_base)
          encrypted_data = crypt.encrypt_and_sign(@order.ordernum)
          
          session[:temp_order] = encrypted_data
          
          if @order.payment_type == 'paypal'          
            format.html { redirect_to express_checkout_cart_index_path() }
          else
            format.html { redirect_to final_check_cart_index_path() }  
          end
      
          
        else
          
          @order_items = Cart.check_items_in_cart(cookies[:cart_ladyboo], "for_cart")
          @ship_to = order_params[:ship_to] if order_params[:ship_to].in? ["taiwan","island","overseas"]

          flash.now[:notice] = @order.errors.first[1]
          format.html { render action: "check"}
        end
      end
    # rescue
    #   flash[:notice] = "Oops..."
    #   reset_everything_about_cart
    #   redirect_to root_path
    # end
  end
  
  def final_check

    crypt = ActiveSupport::MessageEncryptor.new(Ladyboo::Application.config.secret_key_base)
    
    begin
      ordernum = crypt.decrypt_and_verify(session[:temp_order])
    rescue => e
      redirect_to cart_index_path, notice: "交易過期 請重新下單" and return
    end

    begin
      if Order.find_by_ordernum(ordernum).nil?
        #something wrong page
        redirect_to cart_index_path, notice: "交易過期 請重新下單" and return
        #redirect_to final_check_cart_index_path(err: "Something went wrong!") 
      else
        @order = Order.find_by_ordernum(ordernum) #Order.where("ordernum = ? ", ordernum).first
        @order_items = Cart.check_items_in_cart(cookies[:cart_ladyboo], "for_cart")

        cart_sum = sum_cart_items(@order_items)

        # ORDER ATTRIBUTES
        @order.update({ shipping_fee: define_shipping_fee(@order, cart_sum), token: params[:token], payerid: params[:PayerID]} )
      end
    rescue
      flash[:notice] = "Oops..."
      reset_everything_about_cart
      redirect_to root_path
    end

  end

  def confirm 

    crypt = ActiveSupport::MessageEncryptor.new(Ladyboo::Application.config.secret_key_base)
    
    begin
      ordernum = crypt.decrypt_and_verify(session[:temp_order])
    rescue => e
      session[:temp_order] = nil
      redirect_to cart_index_path, alert: "交易過期 請重新下單" and return
    end

    @order = Order.find_by_ordernum(ordernum) #Order.where("ordernum = ? ", ordernum).first

    if @order.nil?
      session[:temp_order] = nil
      redirect_to cart_index_path, alert: "交易過期 請重新下單" and return
    end

    begin
      # chech items still alive 
      #can be isolated
      unless @order.nil?
        @order.subscribe(Orderlog.new)  
        check_item_are_alive(@order)

        if @items_all_alive == false
          
          #delete cookies item
          if @items_all_dead == true
            
            #delete all
            cookies.delete(:cart_ladyboo)
            
            session[:temp_order] = nil
            redirect_to cart_index_path, alert: "商品已下架 請重新下單" and return
          else
            
            # partial dead...
            @cart_ladyboo_items = JSON.parse_if_json(cookies[:cart_ladyboo]) || Hash.new
            cookies[:cart_ladyboo] = Cart.check_cookies(@cart_ladyboo_items)

            session[:temp_order] = nil
            redirect_to cart_index_path, alert: "部分商品已下架 請重新下單" and return
          end
        end
      end
      # check items still alive END

      # make sure checkout won't run out of stock
      run_out_of_stock = false
    rescue
      flash[:notice] = "Oops..."
      reset_everything_about_cart
      redirect_to root_path
    end

    Orderitem.transaction do 
      begin
        
        @order_items = @order.orderitems
        @stocks = Stock.assigned_amount.where(:id => @order_items.map{ |item| item.stock_id })

        @stocks.each do |stock|
          itemstock = @order_items.detect{ |item| item.stock_id == stock.id }
          itemstock.lock!

          #p stock.amount
          stock.amount -= itemstock.amount 
          #p stock.amount
          stock.save!

          if(stock.amount <= 0)
            #mail to admin
          end
        end

      rescue
        run_out_of_stock = true
      end
    end
    # make sure checkout won't run out of stock END

    if( !@order.nil? && @order.payment_type == "credit_card" && run_out_of_stock == false)
        
      redirect_to post_order_cart_index_path(@order) 
      #session[:temp_order] = nil

    elsif ( !@order.nil? && @order.payment_type == "Vaccount" && run_out_of_stock == false)
      begin 
        @ordersum = sum_order_items(@order.orderitems) + get_shipping_fee_from_order(@order)
        @vaccount = generate_vaccount(@order.ordernum, @ordersum)

        if !@vaccount.nil? && @vaccount.length == 14
          @order.update_column(:accountinfo, @vaccount.to_s )
          order_goto_next_state(@order)
          
          crypt = ActiveSupport::MessageEncryptor.new(Ladyboo::Application.config.secret_key_base)
          encrypted_data = crypt.encrypt_and_sign(@vaccount)
          
          session[:final] = encrypted_data

          redirect_to finish_cart_index_path()
        else
          #something went wrong
          redirect_to cart_index_path, alert: "交易失敗 請重新下單" 
        end
        #session[:temp_order] = nil
      rescue
        @order.subscribe(Orderlog.new) 
        #roll back stock
        Orderitem.rollback_stock(@order)
        @order.checkout_failed!

        redirect_to fail_cart_index_path(params)
      end
    elsif ( !@order.nil? && @order.payment_type == "paypal" && run_out_of_stock == false)
      begin 
        @ordersum = sum_order_items(@order.orderitems) + get_shipping_fee_from_order(@order)

        #paypal test: final check page detail
        response = EXPRESS_GATEWAY.purchase(@ordersum*100,
          { token: @order.token,
            payer_id: @order.payerid,
            currency: "TWD",
          }
        )
        
        #ActiveMerchant::Billing::PaypalExpressResponse:0x00000105fa29d0 
        #@params={"timestamp"=>"2014-10-15T07:40:06Z", "ack"=>"Failure", "correlation_id"=>"b7368bd0ec903", "version"=>"72", "build"=>"13298800", "do_express_checkout_payment_response_details"=>nil, "message"=>"Invalid token.", "error_codes"=>"10410", "Timestamp"=>"2014-10-15T07:40:06Z", "Ack"=>"Failure", "CorrelationID"=>"b7368bd0ec903", "Errors"=>{"ShortMessage"=>"Invalid token", "LongMessage"=>"Invalid token.", "ErrorCode"=>"10410", "SeverityCode"=>"Error"}, "Version"=>"72", "Build"=>"13298800", "DoExpressCheckoutPaymentResponseDetails"=>nil}, @message="Invalid token.", @success=false, @test=true, @authorization=nil, @fraud_review=false, @avs_result={"code"=>nil, "message"=>nil, "street_match"=>nil, "postal_match"=>nil}, @cvv_result={"code"=>nil, "message"=>nil}>
        
        if response.success?
          order_goto_next_state(@order)
          redirect_to finish_cart_index_path()
        else
          #something went wrong
          redirect_to cart_index_path, alert: "交易失敗 請重新下單" 
        end
        

      rescue
        @order.subscribe(Orderlog.new) 
        #roll back stock
        Orderitem.rollback_stock(@order)
        @order.checkout_failed!

        redirect_to fail_cart_index_path(params)
      end
    elsif (!@order.nil? && run_out_of_stock == false)
      begin
        order_goto_next_state(@order)
        redirect_to finish_cart_index_path
        #session[:temp_order] = nil
      rescue
        @order.subscribe(Orderlog.new) 
        #roll back stock
        Orderitem.rollback_stock(@order)
        @order.checkout_failed!

        redirect_to fail_cart_index_path(params)
      end
    else
      #something wrong page
      redirect_to cart_index_path, alert: "部分商品庫存不足 請重新確認數量後再行下單" 
      #format.html { redirect_to cart_index_path(err: "Something went wrong!") }
    end

    session[:temp_order] = nil

  end

  def post_order
    
    begin
      @order = current_user.orders.includes(:orderitems).find_by_id(params[:id])
    rescue
      flash[:notice] = "Oops..."
      reset_everything_about_cart
      redirect_to root_path
    end
  end

  def receive_result
    # {"authCode"=>"PP9010",
    #  "lastPan4"=>"5100",
    #  "status"=>"0",
    #  "merID"=>"54158359",
    #  "xid"=>"O-OBJECT-20141015143412.607-0027",
    #  "lidm"=>"CR97298383830",
    #  "cardBrand"=>"VISA",
    #  "pan"=>"490723******5100",
    #  "errcode"=>"00",
    #  "currency"=>"",
    #  "errDesc"=>"",
    #  "authRespTime"=>"20141015143439",
    #  "amtExp"=>"0",
    #  "authAmt"=>"101"}

    # reconsider timeout situation

    if(params[:errcode] == "00" && params[:status] == "0")
      @order = Order.includes(:orderitems).find_by_ordernum(params[:lidm])
      #@ordersum = sum_order_items(@order.orderitems) + get_shipping_fee_from_order(@order)

      order_goto_next_state(@order) #@order.checkout_succeeded_general!
      redirect_to finish_cart_index_path  
    else
      @order = Order.includes(:orderitems).find_by_ordernum(params[:ONO])

      @order.subscribe(Orderlog.new)  
      #roll back stock
      Orderitem.rollback_stock(@order)
      @order.checkout_failed!

      redirect_to fail_cart_index_path(params)
    end
    
  end

  def fail
    @returnparams = params
    # cookies.delete(:cart_ladyboo)
    session[:final] = nil
    
  end

  def finish
    crypt = ActiveSupport::MessageEncryptor.new(Ladyboo::Application.config.secret_key_base)
    @vaccount = crypt.decrypt_and_verify(session[:final]) unless session[:final].nil?

    cookies.delete(:cart_ladyboo)
    session[:final] = nil
  end

  def add
    if(params[:cart][:amount].to_i > 0)
      @stock = Stock.find_by_id(params[:cart][:stock])
      
      # for grind attribute
      # item_attributes = Hash.new
      # item_attributes["stock_id"] = @stock.id
      # item_attributes["amount"] = params[:cart][:amount]
      # item_attributes["needgrind"] = params[:cart][:needgrind]
      # item_attributes["grindlevel"] = params[:cart][:grindlevel]
      
      if(@stock)
        @result = Cart.check_stock(cookies[:cart_ladyboo], @stock, params[:cart][:amount].to_i)
        cookies[:cart_ladyboo] = { value: @result[:cart_items], httponly: true }

        @cart_message = @result[:cart_message]
      else
        @cart_message = "找不到商品"
      end
    else
      @cart_message = "請輸入正確數量"
    end

    respond_to do |format|
      format.html { redirect_to :back, notice: @cart_message }
    end

  end

  def plus
    @result = Cart.plus_stock(cookies[:cart_ladyboo], params[:id])
    cookies[:cart_ladyboo] = { value: @result[:cart_items], httponly: true }

    @cart_message = @result[:cart_message] unless @result[:cart_message].empty?

    respond_to do |format|
      if @cart_message
        format.html { redirect_to cart_index_path, alert: @cart_message }
      else
        format.html { redirect_to cart_index_path, notice: '更新購物車！' }
      end
    end
  end

  def minus
    @result = Cart.minus_stock(cookies[:cart_ladyboo], params[:id])
    cookies[:cart_ladyboo] = { value: @result[:cart_items], httponly: true }

    @cart_message = @result[:cart_message] unless @result[:cart_message].empty?

    respond_to do |format|
      if @cart_message
        format.html { redirect_to cart_index_path, alert: @cart_message }
      else
        format.html { redirect_to cart_index_path, notice: '更新購物車！' }
      end
    end
  end

  def delete_by_attribute
    @result = Cart.minus_partial_stock_to_zero(cookies[:cart_ladyboo], params[:id])
    cookies[:cart_ladyboo] = { value: @result[:cart_items], httponly: true }

    @cart_message = @result[:cart_message]

    respond_to do |format|
      format.html { redirect_to cart_index_path }
    end
  end

  def delete
    @result = Cart.delete_stock(cookies[:cart_ladyboo], params[:id])
    cookies[:cart_ladyboo] = { value: @result[:cart_items], httponly: true }

    @cart_message = @result[:cart_message]

    respond_to do |format|
      format.html { redirect_to cart_index_path }
    end
  end

  #paypal - test: check out with paypal 
  def express_checkout
    crypt = ActiveSupport::MessageEncryptor.new(Ladyboo::Application.config.secret_key_base)
    
    begin
      ordernum = crypt.decrypt_and_verify(session[:temp_order])
    rescue => e
      redirect_to cart_index_path, notice: "交易過期 請重新下單" and return
    end

    begin
      if Order.find_by_ordernum(ordernum).nil?
        #something wrong page
        redirect_to cart_index_path, notice: "交易過期 請重新下單" and return
        #redirect_to final_check_cart_index_path(err: "Something went wrong!") 
      else
        @order = Order.find_by_ordernum(ordernum) #Order.where("ordernum = ? ", ordernum).first
        @order_items = Cart.check_items_in_cart(cookies[:cart_ladyboo], "for_cart")

        cart_sum = sum_cart_items(@order_items)
        shipping_fee = define_shipping_fee(@order, cart_sum)
        total_amount = cart_sum + shipping_fee
        
        express_items = Array.new
        @order_items.each do |item|
          element = {name: item[:name], description: item[:stock_name], quantity: item[:amount].to_s, amount: item[:price_for_sale].to_i*100}
          express_items << element
        end
        #shipping
        if shipping_fee > 0 
          ship_element = {name: '運費', description: ship_to_where(@order), quantity: '1', amount: shipping_fee.to_i*100}
          express_items << ship_element
        end
        p total_amount
        response = EXPRESS_GATEWAY.setup_purchase(total_amount.to_i*100,
          { ip: request.remote_ip,
          return_url: final_check_cart_index_url,
          cancel_return_url: cart_index_url,
          currency: "TWD",
          no_shipping: 1,
          allow_guest_checkout: false,
          items: express_items#[{name: "Order", description: "Order description", quantity: "1", amount: total_amount*100}]
          }
        )
        
        redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
      end
    rescue
      flash[:notice] = "Oops..."
      reset_everything_about_cart
      redirect_to root_path
    end
    

  end

  private
    def order_params
      params.require(:order).permit(:buyer_name, :buyer_tel, :receiver_name, :receiver_tel, :receiver_address, :payment_type, :delivery_type, :order_memo, :invoice_type, :invoice_title , :invoice_companynum, :ship_to, :payerid, :token, :invoice_address)
    end

    def order_goto_next_state(order)
      case(order.payment_type)
      when "atm_transfer"
        order.checkout_succeeded_ATM!
      when "Vaccount"
        order.checkout_succeeded_Vaccount!
      when "paypal"
        order.checkout_succeeded_general!
      when "credit_card"
        order.checkout_succeeded_general!
      when "COD"
        order.checkout_succeeded_COD!
      end
    end

    def recheck_delivery_type(order)
      type_id = 0
      if order.payment_type == "COD"
        # and ceiling > 
        if order.ship_to == "taiwan" 
          type_id = Delivery.where("shipping_condition = 'taiwan' and iscod = 'yes'").first.id
        end
        if  order.ship_to == "island" 
          type_id = Delivery.where("shipping_condition = 'island' and iscod = 'yes'").first.id
        end

      else
        
        if order.ship_to == "taiwan"
          type_id = Delivery.where("shipping_condition = 'taiwan' and iscod = 'no'").first.id
        end

        if order.ship_to == "island"
          type_id = Delivery.where("shipping_condition = 'island' and iscod = 'no'").first.id
        end

        if order.ship_to == "overseas"
          type_id = Delivery.where("shipping_condition = 'overseas' and iscod = 'no'").first.id
        end

      end

      return type_id

    end

    def define_shipping_fee(order, sum)

      current_delivery_type = Delivery.find(recheck_delivery_type(@order))
      
      if sum > current_delivery_type.discount_criteria
        current_delivery_type.discount_fee
      else
        current_delivery_type.normal_fee
      end

    end

    def check_item_are_alive(order) #check item stock exist
      @items_all_alive = true
      @items_dead = Array.new
      @items_all_dead = false

      if order.orderitems.count == 0
        @items_all_alive = false
        @items_all_dead = true
      else
        order.orderitems.each do |item|
          if Stock.find_by_id(item.stock_id).nil? || Stock.find_by_id(item.stock_id).product.status == 'disable'
            @items_all_alive = false 
            @items_all_dead = true if order.orderitems.count == 1
        
            @items_dead << item.stock_id.to_s
          end
        end
      end

      #@result = { items_all_alive: @items_all_alive, items_dead: @items_dead , alldead: @items_all_dead}

    end

    def set_ship_var
      @ship_to = @@ship_to ||= nil
    end

    def restore_temp_order
      session[:temp_order] = nil 
    end

    def reset_everything_about_cart
      cookies.delete(:cart_ladyboo)
      session[:temp_order] = nil
      session[:final] = nil
    end

end