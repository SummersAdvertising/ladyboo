#encoding: utf-8
class Admin::DeliveriesController < AdminController
  authorize_resource
  before_action :set_delivery, :except => [:index]

  def index

    @deliveries = Delivery.all

  end

  def new
    @delivery = Delivery.new
  end
    
  def create

    @delivery = Delivery.new(delivery_params)

    respond_to do |format|
      if @delivery.save
        format.html { redirect_to admin_deliveries_path(), notice: 'delivery was successfully created.' }
      else
        format.html { redirect_to :back, notice: @delivery.errors.full_messages }
      end
    end

  end

  def show

  end

  # GET /admin/deliveries/1/edit
  def edit
    
  end

  def update

    respond_to do |format|
      if @delivery.update(delivery_params)
        format.html { redirect_to admin_deliveries_path, notice: 'Delivery was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :back }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/deliveries/1
  # DELETE /admin/deliveries/1.json
  def destroy

    @delivery.destroy
    respond_to do |format|
      format.html { redirect_to admin_deliveries_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_delivery
    @delivery = Delivery.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def delivery_params
    params.require(:delivery).permit(:name, :tracking_url, :normal_fee, :discount_fee, :discount_criteria)
  end

end