#encoding: utf-8
class CategoriesController < ApplicationController
  def index
    @category = Category.without_root_node.first

    respond_to do |format|
      if(@category)
        format.html { redirect_to category_path(@category) }
      else
        format.html { redirect_to root_path, :alert => "找不到此產品分類" }
      end
    end   

  end

  def show
    begin 
      @current_root = Category.return_root_node
      @categories = Category.get_level_hierarchy()

      @categories_all = Category.includes(:galleries)
      @category = @categories_all.detect {|category| category.id == params[:id].to_i }
      
      redirect_to categories_path and return if @category.nil?
      
      @parent_cate = Category.find(@category.parent_id)
      
      if @category.depth <= 1
        all_descendants_product_ids = Category.where(parent_id: @category.id).pluck(:id)
        @products = Product.enabled.where(category_id: all_descendants_product_ids).includes(:galleries, :category, :stocks).page(params[:page])
      else
        @products = Product.includes(:galleries, :category, :stocks).front_show_by_cate(params[:id].to_i).page(params[:page])
      end
      
    rescue
      redirect_to categories_path
    end
  end
end