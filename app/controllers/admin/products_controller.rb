 #encoding: utf-8
class Admin::ProductsController < AdminController
  
  before_action :set_product_with_category, only: [:create, :show]
  before_action :set_product, only: [:edit,:update,:destroy]
  #before_action :get_product_cate, only: [:create]
  
  def show
    # @com_accessories = @product.accessories.where(type: 'ComplimentaryAccessory').includes(:galleries)
    # @opt_accessories = @product.accessories.where(type: 'OptionalAccessory').includes(:galleries)
    # @features = @product.features.includes(:galleries)
    # @colors = @product.colors.includes(:galleries)
    # @cover = @product.galleries.where(type: 'ProductCover')
    # @sliders = @product.galleries.where(type: 'ProductSlider') 
    # @photos = @product.galleries.where(type: 'ProductPhotoGallery')
    # @dms = @product.galleries.where(type: 'ProductDMFile')
  end

  def create

    @product = Product.create()

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
    @gallery_count = @product.galleries.select{ |v| v['type'] == "ProductCover" }.count
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
    @latestAttach = ProductCover.create(:attachment => params[:attachment], :attachable => @product, :file_name => display_name) if params[:attachment]

    @product.update(product_params.merge({:status => "enable"})) 
    
    respond_to do |format|
      if @product.save
        format.html { redirect_to :back, notice: '更新成功' }
        #format.html { redirect_to admin_product_cate_product_path(@product.product_cate_id, @product) }
      else
        format.html { render :back, notice: @product.errors.full_messages }
      end      
    end

  end

  def destroy
    
    @product.destroy
    
    redirect_to :back
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
      :material_1, :material_2, :wash_1, :wash_2, :wash_3, :model_1, :model_2)
  end

end
 