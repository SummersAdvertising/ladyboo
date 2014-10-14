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
      @products = Product.front_show_by_cate(params[:id].to_i)
    rescue
      redirect_to categories_path
    end
  end
end