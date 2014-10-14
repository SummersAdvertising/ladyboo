#encoding: utf-8
class Useradmin::OrdersController < UseradminController
  before_action :order_params, only: [:atm_transfered]
  
  def index
    @orders = current_user.orders.where("aasm_state != 'hold'").where("created_at >= ? ", 1.year.ago).order(created_at: :desc)
  end
  
  def show
    @order = current_user.orders.includes(:orderitems).includes(:orderlogs).find_by_id(params[:id])

    if(@order)
    	#@orderask = @order.orderasks.new
    	#@orderasks = Orderask.where(:order_id => @order.id)
    else
    	redirect_to useradmin_orders_path #, alert: "找不到訂單"
    end
  end

  def atm_transfered
    @order = current_user.orders.find_by_id(params[:id])
    
    if @order
      if @order.update(order_params)
        @order.atm_transfered!
        redirect_to :back, notice: "匯款帳號已更新"  
      else
        flash[:notice] = @order.errors.first[1]
        redirect_to :back
      end
    else
      redirect_to useradmin_orders_path #, alert: "找不到訂單"
    end
    
    
  end

  private

  def order_params
    params.require(:order).permit(:accountinfo)
  end

end