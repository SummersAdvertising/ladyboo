#encoding: utf-8
class Admin::CategoriesController < AdminController
  before_action :set_category, only: [:update ,:destroy]

  def index
    @category = Category.new
    @categories = Category.for_admin.where("depth = 1")
  end

  def show
    @category = Category.includes(:products).find(params[:id])
    @categories = Category.where("parent_id = #{@category.id}")
    @new_cate = Category.new
    @breadcrumb = @category.find_my_direct_parent
  end

  def create

    @category = Category.new(product_cate_params)
    @category.save

    if params[:filename].present? 
      display_name = params[:filename]
    else 
      display_name = "#{@category.name}-CATEGORY-#{@category.galleries.count + 1}"
    end
      
    @latestAttach = CategoryCoverGallery.create(:attachment => params[:attachment], :attachable => @category, :file_name => display_name) if params[:attachment]


    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def update

    if params[:filename].present? 
      display_name = params[:filename]
    else 
      display_name = "#{@category.name}-CATEGORY-#{@category.galleries.count + 1}"
    end
      
    @latestAttach = CategoryCoverGallery.create(:attachment => params[:attachment], :attachable => @category, :file_name => display_name) if params[:attachment]
    
    @category.update_attributes(product_cate_params) if @category

    redirect_to :back
  end

  def destroy

    #@category.destroy if @category && @category.products.count == 0
    deletable = true
    if @category.products.count > 0
      flash[:alert] = "此分類下仍有產品 無法刪除" 
      deletable = false
    end
    
    # prevent delete by mistake
    Category.where(id: @category.descendents).each do |category|
      if category.products.count > 0
        flash[:alert] = "分類 [#{category.name}] 下仍有產品 無法刪除"
        deletable = false
        break
      end
    end
    
    @category.destroy if deletable == true
    
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_cate_params
      params.require(:category).permit(:name, :parent_id, :depth, :attachment)
    end
end