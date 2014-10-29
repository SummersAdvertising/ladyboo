class Admin::StocksController < AdminController
  #authorize_resource
  before_action :set_stock, only: [:update ,:destroy]

  def index
    @stocks = Stock.by_product(params[:product_id]).all
    @stock = Stock.new

    
    @product = Product.find_by_id(params[:product_id])
    @category = @product.category if @product
    
  end

  def create
    @stock = Stock.new(stock_params.merge({:product_id => params[:product_id]}))
    @stock.save

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def update
    
    @stock.update_attributes(stock_params) if @stock
    # need rule
    @stock.update_column(:name, "#{@stock.description_1}-#{@stock.description_2}")

    redirect_to :back
  end

  def destroy
    @stock.destroy if @stock

    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:name, :description_1, :description_2, :amount, :assign_amount)
    end
end