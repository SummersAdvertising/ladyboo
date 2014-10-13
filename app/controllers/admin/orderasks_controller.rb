class Admin::OrderasksController < AdminController
  #authorize_resource
  
  def index
    @orderasks = Orderask.new_asks.includes(:order).page(params[:page])
  end

  def history
    @orderasks = Orderask.history_asks.includes(:order).page(params[:page])
  end

  def update
    @orderask = Orderask.find_by_id(params[:id])

    if(@orderask)
      @orderask.status = "done"
      @orderask.save
    end
    
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end
end