#encoding: utf-8
class Admin::MeasurementsController < AdminController
  
  before_action :set_product, only: [:index, :new, :create, :edit, :update]
  before_action :set_measurement, only: [:edit, :update, :destroy]

  def index
    @measurements = @product.measurements
  end

  def new
    @measurement = @product.measurements.new
  end

  def create
    @measurement = @product.measurements.new(measurement_params)

    respond_to do |format|
    if @measurement.save
        format.html { redirect_to admin_category_product_measurements_path(params[:category_id], params[:product_id]), notice: 'successfully created.' }
      else
        flash.now[:notice] = @measurement.errors.full_messages 
        format.html { render :new }
      end
    end

  end
  
  def edit 

  end

  def update
    @measurement.update(measurement_params) 
    
    respond_to do |format|
      if @measurement.save
        format.html { redirect_to admin_category_product_measurements_path(@product.category_id, @product), notice: '更新成功' }
      else
        format.html { render :back, notice: @measurement.errors.full_messages }
      end      
    end
  end

  def destroy
    
    @measurement.destroy
    
    redirect_to :back
  end

  private

  def set_product
    @product = Product.find_by_id(params[:product_id])
  end

  def set_measurement
    @measurement = Measurement.find_by_id(params[:id])
  end

  def measurement_params
    params.require(:measurement).permit(:title, :status, :context_1, :context_2, :context_3, :context_4, :context_5, :context_6)
  end

end