#encoding: utf-8
class Useradmin::OrderasksController < UseradminController
  
  def new
    @order = current_user.orders.find_by_id(params[:id])
    
    if(@order)
      @orderask = @order.orderasks.new
      #@orderasks = Orderask.where(:order_id => @order.id)
    else
      redirect_to useradmin_orders_path #, alert: "找不到訂單"
    end


  end

  def create
    @order = current_user.orders.find_by_id(params[:id])
    @order.orderasks.create(orderask_params) if @order

    respond_to do |format| 
      if @order.save
        format.html { redirect_to useradmin_order_path(@order) } 
        CamaMailer.new_order_ask(@order).deliver
      else
        @orderask = @order.orderasks.new
        #flash[:notice] = @order.errors.first[1]
        format.html { render :new } 
      end
    end
  end

  private
    def orderask_params
      params.require(:orderask).permit(:description)
    end
end