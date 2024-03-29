 #encoding: utf-8
class Admin::ProductsController < AdminController
  
  before_action :set_product_with_category, only: [:create, :show]
  before_action :set_product, only: [:edit,:update,:destroy,:change_status]
  after_action :disable_product_when_edit, only: [:create, :update, :upload_photo, :update_parapraph]
  
  
  def show
    # @com_accessories = @product.accessories.where(type: 'ComplimentaryAccessory').includes(:galleries)
    # @opt_accessories = @product.accessories.where(type: 'OptionalAccessory').includes(:galleries)
    # @features = @product.features.includes(:galleries)
    # @colors = @product.colors.includes(:galleries)
    # @cover = @product.galleries.where(type: 'ProductCoverGallery')
    # @sliders = @product.galleries.where(type: 'ProductSlider') 
    # @photos = @product.galleries.where(type: 'ProductPhotoGallery')
    # @dms = @product.galleries.where(type: 'ProductDMFile')
  end

  def create

    @product = Product.create()
    @product.article = Article.new

    @category = Category.find_by_id(params[:category_id])
    @category.products << @product

    respond_to do |format|
      if( @product.errors.any? )
        format.html { redirect_to :back, alert: "新增失敗" }
      else
        format.html { redirect_to edit_admin_category_product_path(@category, @product) }
      end
    end
  end

  def edit
    @gallery_count = @product.galleries.select{ |v| v['type'] == "ProductCoverGallery" }.count
  end

  def change_status
    @product.status = (@product.status == "enable") ? "disable" : "enable"
    @product.save

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end
  # def slider
  #   @product = Product.find_by_id(params[:product_id])
  #   @gallery_count = @product.galleries.select{ |v| v['type'] == "ProductSlider" }.count
  # end

  # def upload_slider
  #   @product = Product.find_by_id(params[:product_id])
  #   #deal with attachment
  #   if params[:filename].present? 
  #     display_name = params[:filename] 
  #   else 
  #     display_name = "#{@product.name}-product-#{@product.galleries.count + 1}"
  #   end
  #   @latestAttach = ProductSlider.create(:attachment => params[:attachment], :attachable => @product, :file_name => display_name) if params[:attachment]

  #   @product.update(product_params) 
    
  #   respond_to do |format|
  #     if @product.save
  #       format.html { redirect_to :back, notice: '更新成功' }
  #     else
  #       format.html { render :back, notice: @product.errors.full_messages }
  #     end      
  #   end

  # end

  # def dm
  #   @product = Product.find_by_id(params[:product_id])
  #   @gallery_count = @product.galleries.select{ |v| v['type'] == "ProductDMFile" }.count
  # end

  # def upload_dm
  #   @product = Product.find_by_id(params[:product_id])
  #   #deal with attachment
  #   if params[:filename].present? 
  #     display_name = params[:filename] 
  #   else 
  #     display_name = "#{@product.name}-product-#{@product.galleries.count + 1}"
  #   end
  #   @latestAttach = ProductDMFile.create(:attachment => params[:attachment], :attachable => @product, :file_name => display_name) if params[:attachment]

  #   @product.update(product_params) 
    
  #   respond_to do |format|
  #     if @product.save
  #       format.html { redirect_to :back, notice: '更新成功' }
  #     else
  #       format.html { render :back, notice: @product.errors.full_messages }
  #     end      
  #   end
  # end
  def free_paragraph
    @product = Product.find_by_id(params[:product_id])
  end

  def photo
    @product = Product.find_by_id(params[:product_id])
    @gallery_count = @product.galleries.select{ |v| v['type'] == "ProductPhotoGallery" }.count
  end

  def upload_photo
    @product = Product.find_by_id(params[:product_id])
    #deal with attachment
    if params[:filename].present? 
      display_name = params[:filename] 
    else 
      display_name = "#{@product.name}-product-#{@product.galleries.count + 1}"
    end
    @latestAttach = ProductPhotoGallery.create(:attachment => params[:attachment], :attachable => @product, :file_name => display_name) if params[:attachment]

    @product.update(product_params) 
    
    respond_to do |format|
      if @product.save
        format.html { redirect_to :back, notice: '更新成功' }
      else
        format.html { render :back, notice: @product.errors.full_messages }
      end      
    end
  end
  
  def update

    #deal with attachment
    if params[:filename].present? 
      display_name = params[:filename] 
    else 
      display_name = "#{@product.name}-product-#{@product.galleries.count + 1}"
    end
    @latestAttach = ProductCoverGallery.create(:attachment => params[:attachment], :attachable => @product, :file_name => display_name) if params[:attachment]

    @product.update(product_params.merge({:status => "enable"}))
    
    respond_to do |format|
      if @product.save
        format.html { redirect_to :back, notice: '更新成功' }
        #format.html { redirect_to admin_category_product_path(@product.category_id, @product) }
      else
        format.html { redirect_to :back, notice: @product.errors.full_messages }
      end      
    end

  end

  def update_parapraph
    @product = Product.find_by_id(params[:product_id])
    @product.article.update( params.require(:article).permit(:content) )
    
    respond_to do |format|
      if @product.save
        format.html { redirect_to :back, notice: '更新成功' }
        #format.html { redirect_to admin_category_product_path(@product.category_id, @product) }
      else
        format.html { render :back, notice: @product.errors.full_messages }
      end      
    end

  end

  def destroy
    
    @product.destroy
    
    redirect_to :back
  end

  def out_of_stock
    # @products = Product.where
  end

  def disabled

    # @products = Product.where(status: 'disable').order(category_id: :asc)
    # @out_of_stock_category_ids = Category.where(id: @products.pluck(:category_id)).pluck(:parent_id)
    # @out_of_stock_categories = Category.where(id: out_of_stock_category_ids).order(id: :asc) if @products
  end

  def reorder
    errorFlag = false
    params[:products][:reorderset].each_with_index do | productid , index |
      the_product = Product.find(productid)
      if !the_product.nil?
        the_product.update_attribute(:ranking , index+1 )
      else
        errorFlag = true
      end
    end

    respond_to do |format|
      if errorFlag
        format.json { head :no_content }
      else
        flash[:notice] = "重新排序成功"
        format.json do render json: flash end
      end
    end

  end

  private

  def set_product
    @product = Product.find_by_id(params[:id])
  end

  def set_product_with_category
    @product = Product.includes(:category).find_by_id(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :en_name, :price, :price_for_sale, :attachment,
      :status, :ranking, :article_id, :ck_context, :is_new,
      :highlight,
      :material_1, :material_2, :wash_1, :wash_2, :wash_3, :model_1, :model_2,
      :product_no)
  end

  def disable_product_when_edit
    @product.update_attributes({:status => "disable"})
  end

end
 