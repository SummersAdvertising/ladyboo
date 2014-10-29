#encoding: utf-8
class Admin::PickupsController < AdminController

  before_action :set_admin_pickup, only: [:show, :edit ,:update, :destroy]
  #, :create_pickup_attachment, :create_selected_product_attachment
  
  # GET /admin/pickups
  # GET /admin/pickups.json
  def index 
    @pickups = Pickup.for_admin
  end

  #new
  def new
    @pickup = Pickup.new
    @products = Product.where.not(id: Pickup.pluck(:product_id)).order(updated_at: :desc)
  end

  def create
    @pickup = Pickup.new(admin_pickup_params)

    respond_to do |format|
      if @pickup.save
        flash[:notice] = "更新成功"
        format.html { redirect_to admin_pickups_path() }
        #format.js {render :js => "window.location.href=window.location.href;"}
      else
        format.html { redirect_to :back , notice: @pickup.errors.full_messages }
      end
    end  
  end

  # GET /admin/pickups/1
  # GET /admin/pickups/1.json
  def show
  end

  # GET /admin/pickups/1/edit
  def edit
    # selected product
    @products = Product.order(updated_at: :desc).all
  end

  # PATCH/PUT /admin/pickups/1
  # PATCH/PUT /admin/pickups/1.json
  def update
    #@pickup = Pickup.find(params[:id])
    # thought-1: depends on type
    @pickup.update ( admin_pickup_params )
    
    respond_to do |format|
      if @pickup.save
        format.html { redirect_to admin_pickups_path, notice: 'Successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :back }
        format.json { render json: @pickup.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /admin/pickups/1
  # DELETE /admin/pickups/1.json
  def destroy
    @pickup.destroy
    respond_to do |format|
      flash[:notice] = "刪除成功"
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin_pickup
    @pickup = Pickup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_pickup_params
    params.require(:pickup).permit(:title, :description, :product_id ,:ranking, :status)
  end

end
